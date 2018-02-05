# == Schema Information
#
# Table name: city_supports
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  date        :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CitySupport < ApplicationRecord
  has_many :photos, as: :attacheable, dependent: :destroy
  belongs_to :city_support_category
  
  accepts_nested_attributes_for :photos, allow_destroy: true

  scope :filter_by_title_or_description, ->(search_term) { where('city_supports.title ilike ? or city_supports.description ilike ?', "%#{search_term}%", "%#{search_term}%") }

  class << self
    def fetch_all(options)
      search_term = options['search'] if options.present? && options['search'].present?

      city_supports = all
      city_supports = city_supports.filter_by_title_or_description(search_term) if search_term.present?
      city_supports
    end
  end
end
