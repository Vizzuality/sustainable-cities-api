# frozen_string_literal: true
module V1
  class CountryResource < JSONAPI::Resource
    caching

    attributes :name, :region_name, :iso, :region_iso, :country_centroid, :region_centroid, :is_active

    has_many :cities

    filters :id, :name, :iso, :is_featured

    def custom_links(_)
      { self: nil }
    end
  end
end
