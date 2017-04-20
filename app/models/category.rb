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
#

class Category < ApplicationRecord
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

  class << self
    def fetch_all(options=nil)
      cat_type_name = options['category_type'] if options.present? && options['category_type'].present?
      type_name     = options['type']          if options.present? && options['type'].present?

      categories = all.includes(:parent, :children)
      categories = categories.by_type(cat_type_name) if cat_type_name.present? && !cat_type_name.match?(/All|Tree/)

      if cat_type_name.present? && cat_type_name.match?('Tree')
        categories = categories.top_level
        categories = categories.by_type(type_name) if type_name.present?
      end

      categories
    end
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
