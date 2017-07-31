# frozen_string_literal: true
module V1
  class ProjectResource < JSONAPI::Resource
    caching

    attributes :name, :slug, :situation, :solution, :category_id, :country_id, :tagline,
               :operational_year, :project_type, :is_active, :is_featured,
               :deactivated_at, :publish_request, :published_at, :bme_tree,
               :category_level_2

    has_one :country
    has_one :category

    has_many :project_bmes

    has_many :impacts
    has_many :cities
    has_many :users
    has_many :photos
    has_many :documents
    has_many :external_sources
    has_many :comments


    filters :id, :name, :situation, :solution_id, :category_id, :country_id,
            :operational_year, :project_type, :is_active, :is_featured, :published_at

    filter :category_slug, apply: ->(records, value, _options) {
      id = Category.find_by(slug: value[0]).id rescue nil
      records.joins(:category).where('categories.id': id) if id
    }

    filter :category_id, apply: ->(records, value, _options) {
      id = Category.find(value[0]).id rescue nil
      records.joins(:category).where('categories.id': id) if id
    }

    filter :city_iso, apply: ->(records, value, _options) {
      id = City.where(iso: value[0]).pluck(:id) rescue nil
      records.joins(:cities).where('project_cities.city_id': id) if id
    }

    filter :city_id, apply: ->(records, value, _options) {
      id = City.find_by(id: value[0]).id rescue nil
      records.joins(:cities).where('project_cities.city_id': id) if id
    }


    filter :projects_category, apply: ->(records, value, _options) {
      slug = value[0]
      category = Category.find_by(slug: slug)

      if category.present? && category.category_type == 'Solution'
        children = category.children

        if category.level == 1
          if children.present?
            children_ids = children.pluck(:id)
            categories_ids = Category.where(parent_id: children_ids).pluck(:id)
            ids = children_ids + categories_ids << category.id

            projects = Project.where(category_id: ids)
          end

        elsif category.level == 2
          if children.present?
            ids = children.pluck(:id) << category.id
            projects = Project.where(category_id: ids)
          end
          
        elsif category.level == 3
          projects = category.projects
        end
        records.where(id: projects.pluck(:id))

      else
        Project.none
      end
    }

    filter :bme_slug, apply: ->(records, value, _options) {
      category = Category.find_by(slug: value[0])
      if category.category_type == 'Bme'
        all_bmes = category.children_bmes.pluck(:id).uniq
        if all_bmes.present?
          records.joins(:bmes).where('project_bmes.bme_id': all_bmes)
        else
          Project.none
        end
      end

    }

    def operational_year
      object.operational_year.year rescue nil
    end

    def category_level_2
      @model.category.level == 2 ? @model.category.slug : @model.category.parent.slug rescue nil
    end

    def custom_links(_)
      { self: nil }
    end
  end
end
