# frozen_string_literal: true
module V1
  class EnablingResource < JSONAPI::Resource
    caching

    attributes :name, :description, :assessment_value, :is_featured

    has_one :category
    has_many   :bmes

    filters :id, :name, :is_featured, :assessment_value

    def custom_links(_)
      { self: nil }
    end
  end
end
