# frozen_string_literal: true
module V1
  class BusinessModelResource < JSONAPI::Resource
    caching

    attributes :title, :description, :link_share, :link_edit

    belongs_to :solution
  end
end
