# frozen_string_literal: true
module V1
  class ContactResource < JSONAPI::Resource
    caching

    attributes :name, :email

    filters :name, :email

    def custom_links(_)
      { self: nil }
    end
  end
end