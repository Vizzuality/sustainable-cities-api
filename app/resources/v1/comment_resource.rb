# frozen_string_literal: true
module V1
  class CommentResource < JSONAPI::Resource
    caching

    attributes :body, :is_active, :created_at, :updated_at

    has_one :user
    has_one :commentable
    filters :id, :is_active

    def custom_links(_)
      { self: nil }
    end
  end
end
