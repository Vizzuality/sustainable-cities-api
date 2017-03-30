# frozen_string_literal: true
# == Schema Information
#
# Table name: enablings
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  assessment_value :integer          default("Success")
#  category_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Enabling < ApplicationRecord
  enum assessment_value: { Success: 1, Barrier: 2 }

  belongs_to :category, inverse_of: :enablings, touch: true

  has_many :bme_enablings
  has_many :bmes, through: :bme_enablings

  accepts_nested_attributes_for :bmes

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :assessment_value }

  scope :by_name_asc, -> { order('enablings.name ASC') }

  class << self
    def fetch_all(options)
      all.includes(:category, :bmes)
    end
  end
end
