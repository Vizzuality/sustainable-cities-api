# frozen_string_literal: true
module V1
  class CategoryResource < JSONAPI::Resource
    caching

    attributes :name, :slug, :description, :category_type, :label, :level

    has_one :parent
    has_many   :children
    has_many :bmes
    filters :id, :name, :slug, :category_type, :label, :level

    def custom_links(_)
      { self: nil }
    end
  end
end
