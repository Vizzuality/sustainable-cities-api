# frozen_string_literal: true
# == Schema Information
#
# Table name: countries
#
#  id               :integer          not null, primary key
#  name             :string
#  region_name      :string
#  iso              :string
#  region_iso       :string
#  country_centroid :jsonb
#  region_centroid  :jsonb
#  is_active        :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Country < ApplicationRecord
  has_many :users,    inverse_of: :country
  has_many :cities,   inverse_of: :country
  has_many :projects, inverse_of: :country

  validates :name, :iso, presence: true, uniqueness: { case_sensitive: false }

  include Activable

  scope :by_name_asc,  -> { order('countries.name ASC') }

  scope :by_activated,   ->              { where(is_active: true)                    }
  scope :filter_by_name, ->(search_term) { where('countries.name ilike ?', "%#{search_term}%") }

  class << self
    def fetch_all(options)
      search_term = options['search']  if options.present? && options['search'].present?

      countries = includes(:cities)
      countries = countries.filter_by_name(search_term) if search_term.present?
      countries
    end
  end
end
