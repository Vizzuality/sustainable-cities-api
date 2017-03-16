# frozen_string_literal: true
# == Schema Information
#
# Table name: enablings
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  assessment_value :decimal(, )
#  category_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Enabling < ApplicationRecord
  belongs_to :category, inverse_of: :enablings

  has_many :bme_enablings
  has_many :bmes, through: :bme_enablings

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :by_name_asc, -> { order('enablings.name ASC') }

  default_scope { by_name_asc }

  class << self
    def fetch_all(options)
      all
    end
  end
end
