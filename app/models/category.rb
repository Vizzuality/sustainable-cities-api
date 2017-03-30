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
  enum project_type: { Category: 0, Solution: 1, Bme: 2, Impact: 3, Enabling: 4, Timing: 5 }

  belongs_to :parent, class_name: 'Category', foreign_key: :parent_id, touch: true

  has_many :enablings, inverse_of: :category
  has_many :projects,  inverse_of: :category
  has_many :impacts,   inverse_of: :category

  has_many :bme_categories
  has_many :bmes, through: :bme_categories

  validates :name,          presence: true, uniqueness: { case_sensitive: false, scope: :category_type }
  validates :category_type, presence: true, inclusion: { in: %w(Category Solution Bme Impact Enabling Timing) }, on: :create

  scope :by_name_asc, -> { order('categories.name ASC') }

  class << self
    def fetch_all(options)
      all.includes(:parent)
    end
  end
end
