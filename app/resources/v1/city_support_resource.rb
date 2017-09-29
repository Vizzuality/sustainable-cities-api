# frozen_string_literal: true
module V1
  class CitySupportResource < JSONAPI::Resource
    caching

    attributes :title, :description, :date, :image_source

    belongs_to :city_support_category
    has_many :photos
    filters :id, :title, :description, :date

    def self.default_sort
      [{field: 'date', direction: :desc}]
    end

    def custom_links(_)
      { self: nil }
    end
  end
end
