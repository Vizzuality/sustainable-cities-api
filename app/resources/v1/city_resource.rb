# frozen_string_literal: true
module V1
  class CityResource < JSONAPI::Resource
    caching

    attributes :name, :iso, :lat, :lng, :province, :is_featured

    has_one :country
    has_many :projects

    filters :id, :name, :iso, :is_featured

    def custom_links(_)
      { self: nil }
    end
  end
end
