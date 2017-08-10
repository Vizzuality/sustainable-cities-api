# frozen_string_literal: true
module V1
  class BusinessModelResource < JSONAPI::Resource
    caching

    attributes :title, :description, :link_share, :link_edit, :solution_id

    has_one :solution
    has_many :bmes
    has_many :enablings
    has_many :users
  end
end
