# frozen_string_literal: true
module V1
  class CategoryResource < JSONAPI::Resource
    caching

    attributes :name, :slug, :description, :category_type, :label, :level, :children_bmes

    has_one  :parent
    has_many :children
    has_many :bmes
    has_many :projects
    has_many :enablings
    filters  :id, :name, :slug, :category_type, :label, :level

    def custom_links(_)
      { self: nil }
    end
  end
end
