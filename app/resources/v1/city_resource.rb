# frozen_string_literal: true
module V1
  class CityResource < JSONAPI::Resource
    caching

    attributes :name, :iso, :lat, :lng, :province, :is_featured

    has_one :country
    has_many :projects

    filters :id, :name, :iso, :is_featured

    filter :contains_projects, apply: ->(records, value, _options) {
      if value[0] == '0' || value[0] == 'false'
        records
      else
        records.includes(:projects).where.not(projects: { id: nil })
      end
    }

    filter :projects_category, apply: ->(records, value, _options) {
      slug = value[0]
      category = Category.find_by(slug: slug)

      if category.present? && category.category_type == 'Solution'
        if category.projects.present?
          projects = category.projects
        else
          children = category.children
          if category.level == 1
            projects = children.map { |category| category.children.map { |solution| solution.projects } }.flatten rescue []
          elsif category.level == 2
            projects = children.map { |solution| solution.projects }.flatten rescue []
          end
        end

        if projects.present?
          cities_ids = projects.map { |project| project.cities }.flatten.pluck(:id).uniq
          records.where(id: cities_ids)
        else
          City.none
        end
      else
        City.none
      end
    }

    filter :bme_slug, apply: ->(records, value, _options) {
      slug = value[0]
      category = Category.find_by(slug: slug)
      
      if category.present? && category.category_type == 'Bme'
        if category.level == 1
          projects = category.children.map { |second_child| second_child.children }.flatten
                      .map { |third_child| third_child.bmes }.flatten
                      .map { |bme| bme.projects }.flatten rescue []
        elsif category.level == 2
          projects = category.children.map { |child| child.bmes }.flatten
                      .map { |bme| bme.projects }.flatten rescue []
        elsif category.level == 3
          projects = category.bmes.map { |bme| bme.projects }.flatten rescue []
        end

        if projects.present?
          cities_ids = projects.map { |project| project.cities }.flatten.pluck(:id).uniq
          records.where(id: cities_ids)
        else
          City.none
        end
      else
        City.none
      end    
    }

    def custom_links(_)
      { self: nil }
    end
  end
end
