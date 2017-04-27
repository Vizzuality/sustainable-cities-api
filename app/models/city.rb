# frozen_string_literal: true
# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  country_id :integer
#  iso        :string
#  lat        :decimal(, )
#  lng        :decimal(, )
#  province   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class City < ApplicationRecord
  belongs_to :country, inverse_of: :cities, touch: true

  has_many :users, inverse_of: :city
  has_many :project_cities
  has_many :projects, through: :project_cities

  validates :name, presence: true

  scope :by_name_asc, -> { order('cities.name ASC') }

  class << self
    def fetch_all(options)
      all.includes(:country)
    end
  end
end
