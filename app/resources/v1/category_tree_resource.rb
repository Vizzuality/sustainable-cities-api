# frozen_string_literal: true
module V1
  class CategoryTreeResource < JSONAPI::Resource
    caching
    immutable
    model_name 'Category'

    attributes :name, :slug, :description, :category_type, :parent_id, :children

    def id
      @model.id.to_s
    end

    def parent_id
      @model.parent_id.to_s if @model.parent_id.present?
    end

    filters :id, :name, :slug

    def children
      if !@model.is_leaf?
        @children = @model.with_children
        @children.map do |child|
          JSONAPI::ResourceSerializer.new(CategoryTreeResource).serialize_to_hash(child)
        end
      end
    end

    def custom_links(_)
      { self: nil }
    end
  end
end
