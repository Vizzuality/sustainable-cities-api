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

  validates :name,          presence: true, uniqueness: { case_sensitive: false, scope: :category_type         }
  validates :category_type, presence: true, inclusion:  { in: %w(Category Solution Bme Impact Enabling Timing) }, on: :create

  scope :by_name_asc,   ->              { order('categories.name ASC')        }
  scope :by_type,       ->cat_type_name { where(category_type: cat_type_name) }
  scope :top_level,     ->              { where(parent_id: nil)               }
  scope :with_children, ->              { joins(:children).distinct           }
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

	def parent_slug
		self.parent.slug rescue nil
	end

	def attributes
		super.merge({'parent_slug' => parent_slug})
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
