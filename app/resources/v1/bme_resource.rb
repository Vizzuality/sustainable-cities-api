# frozen_string_literal: true
module V1
  class BmeResource < JSONAPI::Resource
    caching

    attributes :name, :description, :is_featured, :slug

    has_many :enablings
    has_many :categories
    has_many :external_sources
    filters :id, :name, :is_featured

    filter :category_id, apply: ->(records, value, _options) {
      id = Category.find_by(id: value[0]).id rescue nil
      records.joins(:categories).where('bme_categories.category_id': id) if id
    }

    filter :category_slug, apply: ->(records, value, _options) {
      id = Category.find_by(slug: value[0]).id rescue nil
      records.joins(:categories).where('bme_categories.category_id': id) if id
    }

    def custom_links(_)
      { self: nil }
    end
  end
end
