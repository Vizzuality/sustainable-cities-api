# frozen_string_literal: true
# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  parent_id     :integer
#  category_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  label         :string
#  slug          :string
#  level         :integer
#

class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  enum project_type: { Category: 0, Solution: 1, Bme: 2, Impact: 3, Enabling: 4, Timing: 5 }.freeze

  # Parent-Children-Relations
  belongs_to :parent,   class_name: 'Category', touch: true
  has_many   :children, class_name: 'Category', foreign_key: :parent_id

  has_many :enablings, inverse_of: :category
  has_many :projects,  inverse_of: :category
  has_many :impacts,   inverse_of: :category

  has_many :bme_categories
  has_many :bmes, through: :bme_categories

  has_one :document, as: :attacheable, dependent: :destroy

  after_save { children.find_each(&:touch) }
  after_save { projects.find_each(&:touch) }
  after_save { bmes.find_each(&:touch)     }

  validates :name,          presence: true, uniqueness: { case_sensitive: false, scope: :category_type         }
  validates :category_type, presence: true, inclusion:  { in: %w(Category Solution Bme Impact Enabling Timing) }

  attr_accessor :skip_validation
  after_save :update_level unless :skip_validation

  accepts_nested_attributes_for :document, allow_destroy: true

  default_scope { where(private: false) }
  scope :by_name_asc,   ->              { order('categories.name ASC')        }
  scope :by_type,       ->cat_type_name { where(category_type: cat_type_name) }
  scope :top_level,     ->              { where(parent_id: nil)               }
  scope :with_children, ->              { joins(:children).distinct           }
  scope :with_private,  ->              { unscope(where: :private) }
  scope :second_level,	->							{ where(parent_id: nil).map {|c| c.children}.flatten }

  scope :filter_by_name_or_description, ->(search_term) { where('categories.name ilike ? or categories.description ilike ?', "%#{search_term}%", "%#{search_term}%") }

  class << self
    def fetch_all(options)
      cat_type_name = options['category_type'] if options.present? && options['category_type'].present?
      type_name     = options['type']          if options.present? && options['type'].present?
      search_term   = options['search']        if options.present? && options['search'].present?

      categories = all.includes(:parent, :children)
      categories = categories.by_type(cat_type_name) if cat_type_name.present? && !cat_type_name.match?(/All|Tree/)

      if cat_type_name.present? && cat_type_name.match?('Tree')
        categories = categories.top_level
        categories = categories.by_type(type_name) if type_name.present?
      end

      categories = categories.filter_by_name_or_description(search_term) if search_term.present?

      categories
    end
  end

  def children_bmes
    return [] unless category_type == 'Bme'

    category_bmes = get_bmes.sort_by { |bme| bme.name } rescue []

    if category_bmes.present?
      category_bmes.map { |bme| bme_json(bme) }
    else
      []
    end
  end

  def get_bmes
    if level == 3
      bmes
    elsif level == 2
      children.map(&:bmes).flatten.uniq
    else
      children.map { |child| child.children.map(&:bmes).flatten }.flatten.uniq
    end
  end

  def bme_json(bme)
    {
      id: bme.id,
      name: bme.name,
      description: bme.description,
      is_featured: bme.is_featured,
      slug: bme.slug,
      parent_slug: bme.parent_bme_slug
    }
  end

  def update_level
    update_column :level, parent_id.nil? ? 1 : (parent.level + 1)
    children.each do |child|
      child.update_level
    end
  end

  def parent_slug
    self.parent.slug rescue nil
  end

  def attributes
    super.merge({ 'parent_slug' => parent_slug })
  end

  def with_children
    children.includes(children: :parent).distinct
  end

  def has_parent?
    self.parent.present?
  end

  def is_leaf?
    self.children.empty?
  end

  def is_root?
    self.parent.nil?
  end
end
