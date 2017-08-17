# frozen_string_literal: true
module V1
  class PrivateCategoryResource < JSONAPI::Resource
    caching

    attributes :name, :slug, :description, :category_type, :label, :level, :children_bmes, :private, :parent_id

    has_one  :parent,   class_name: 'Category'
    has_many :children, class_name: 'Category'
    has_many :bmes
    has_many :projects
    has_many :enablings
    filters  :id, :name, :slug, :category_type, :label, :level, :private

    def custom_links(_)
      { self: nil }
    end
  end
end
