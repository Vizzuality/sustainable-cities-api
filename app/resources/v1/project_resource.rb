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
            projects = children.map { |category| category.children.map { |solution| solution.projects } }.flatten
          end

        elsif category.level == 2
          if children.present?
            projects = children.map { |solution| solution.projects }.flatten
          end
          
        elsif category.level == 3
          projects = category.projects
        end
        cities_ids = projects.map { |project| project.cities }.flatten.pluck(:id)
        records.joins(:cities).where('project_cities.city_id': cities_ids) if cities_ids.present?

      else
        Project.none
      end
    }

    filter :bme_slug, apply: ->(records, value, _options) {
      category = Category.find_by(slug: value[0])
      if category.category_type == 'Bme'
        all_categories = category.children_bmes
        all_bmes = Category.where(id: all_categories).joins(:bmes).pluck('bmes.id').uniq!
        records.joins(:bmes).where('project_bmes.bme_id': all_bmes) if all_bmes.present?
      end

    }

    def operational_year
      object.operational_year.year rescue nil
    end

    def category_level_2
      @model.category.level == 2 ? @model.category_id : @model.category.parent_id rescue nil
    end

    def custom_links(_)
      { self: nil }
    end
  end
end
