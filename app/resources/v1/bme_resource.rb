# frozen_string_literal: true
module V1
  class BmeResource < JSONAPI::Resource
    caching

    attributes :name, :description, :is_featured

    has_many :enablings
    has_many :categories
    has_many :external_sources
    filters :id, :name, :is_featured

    def custom_links(_)
      { self: nil }
    end
  end
end
