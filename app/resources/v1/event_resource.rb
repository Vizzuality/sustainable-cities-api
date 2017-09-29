# frozen_string_literal: true
module V1
  class EventResource < JSONAPI::Resource
    caching

    attributes :title, :link, :date

    has_many :photos
    filters :id, :title, :link, :date

    def self.default_sort
      [{field: 'date', direction: :desc}]
    end

    def custom_links(_)
      { self: nil }
    end
  end
end
