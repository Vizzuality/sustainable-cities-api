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

  has_many :enablings, inverse_of: :category
  has_many :projects,  inverse_of: :category
  has_many :impacts,   inverse_of: :category

  has_many :bme_categories
  has_many :bmes, through: :bme_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :category_type }

  scope :by_name_asc, -> { order('categories.name ASC') }

  default_scope { by_name_asc }

  class << self
    def fetch_all(options)
      all
    end
  end
end
