# frozen_string_literal: true
module V1
  class CitySupportResource < JSONAPI::Resource
    caching

    attributes :title, :description, :date

    has_many :photos
    filters :id, :title, :description, :date

    def custom_links(_)
      { self: nil }
    end
  end
end
