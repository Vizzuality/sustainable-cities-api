# frozen_string_literal: true
# == Schema Information
#
# Table name: bmes
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Bme < ApplicationRecord
  has_many :bme_enablings
  has_many :enablings, through: :bme_enablings

  has_many :bme_categories
  has_many :categories, through: :bme_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :by_name_asc, -> { order('bmes.name ASC') }

  default_scope { by_name_asc }

  class << self
    def fetch_all(options)
      all
    end
  end
end
