# frozen_string_literal: true
# == Schema Information
#
# Table name: cities
#
#  id          :integer          not null, primary key
#  name        :string
#  country_id  :integer
#  iso         :string
#  lat         :decimal(, )
#  lng         :decimal(, )
#  province    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_featured :boolean          default(FALSE)
#

class City < ApplicationRecord
  belongs_to :country, inverse_of: :cities, touch: true

  has_many :users, inverse_of: :city
  has_many :project_cities
  has_many :projects, through: :project_cities

  after_save { projects.find_each(&:touch) }

  validates :name, presence: true

  scope :by_name_asc, -> { order('cities.name ASC') }

  scope :filter_by_name,    ->(search_term) { where('cities.name ilike ?', "%#{search_term}%") }
  scope :filter_by_country, ->(country_id)  { where(country_id: country_id)                    }
  scope :with_projects,     ->              { joins(:projects).distinct                        }

  class << self
    def fetch_all(options)
      search_term = options['search']  if options.present? && options['search'].present?
      country_id  = options['country'] if options.present? && options['country'].present?

      cities = includes(:country)
      cities = cities.filter_by_name(search_term)   if search_term.present?
      cities = cities.filter_by_country(country_id) if country_id.present?
      cities
    end
  end
end
