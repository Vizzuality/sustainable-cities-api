# frozen_string_literal: true
module V1
  class SessionResource < JSONAPI::Resource
    primary_key :token
    attributes :email, :password, :token

    def custom_links(_)
      { self: nil }
    end
  end
end
