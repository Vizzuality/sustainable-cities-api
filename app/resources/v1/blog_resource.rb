# frozen_string_literal: true
module V1
  class BlogResource < JSONAPI::Resource
    caching

    attributes :title, :link, :date

    has_many :photos
    filters :id, :title, :link, :date

    def custom_links(_)
      { self: nil }
    end
  end
end
