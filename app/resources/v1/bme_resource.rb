# frozen_string_literal: true
module V1
  class BmeResource < JSONAPI::Resource
    caching

    attributes :name, :description, :is_featured, :slug, :category_level_1, :private, :parent_slug, :category_level_1_slug

    has_many :enablings
    has_many :categories
    has_many :external_sources
    has_many :projects
    has_many :private_categories
    has_many :photos
    filters :id, :name, :is_featured

    filter :category_id, apply: ->(records, value, _options) {
      id = Category.find_by(id: value[0]).id rescue nil
      records.joins(:categories).where('bme_categories.category_id': id) if id
    }

    filter :category_slug, apply: ->(records, value, _options) {
      id = Category.find_by(slug: value[0]).id rescue nil
      records.joins(:categories).where('bme_categories.category_id': id) if id
    }

    filter :contains_projects, apply: ->(records, value, _options) {
      if value[0] == '0' || value[0] == 'false'
        records
      else
        records.includes(:projects).where.not(projects: { id: nil })
      end
    }

    filter :city_id, apply: ->(records, value, _options) {
      records.joins(projects: :cities).where("city_id = #{value[0]}")
    }

    def private_categories
      @model.categories.where(private: true)
    end

    def parent_slug
      @model.parent_bme_slug
    end

    def get_category_level_1
      category = categories.select { |category| category.category_type == 'Bme' }[0]

      if category.level == 1
        category
      elsif category.level == 2
        category.parent
      elsif category.level == 3
        category.parent.parent
      end rescue nil
    end

    def category_level_1
      get_category_level_1.name rescue nil
    end

    def category_level_1_slug
      get_category_level_1.slug rescue nil
    end

    def custom_links(_)
      { self: nil }
    end
  end
end
