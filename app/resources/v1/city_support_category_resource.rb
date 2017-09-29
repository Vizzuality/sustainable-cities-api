# frozen_string_literal: true
module V1
  class CitySupportCategoryResource < JSONAPI::Resource
    caching

    attributes :title, :slug

    has_many :city_supports
    filters :id, :slug

    def custom_links(_)
      { self: nil }
    end
  end
end
