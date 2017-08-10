# frozen_string_literal: true
module V1
  class BusinessModelResource < JSONAPI::Resource
    caching

    attributes :title, :description, :link_share, :link_edit, :solution_id

    has_one :solution
    has_many :bmes

  end
end
