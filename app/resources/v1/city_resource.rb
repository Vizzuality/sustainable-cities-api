# frozen_string_literal: true
module V1
  class CityResource < JSONAPI::Resource
    caching

    attributes :name, :iso, :lat, :lng, :province, :is_featured, :project_count, :bmes_quantity

    has_one :country
    has_many :projects
    has_many :photos

    filters :id, :name, :iso, :is_featured, :country_id

    filter :contains_projects, apply: ->(records, value, _options) {
      if value[0] == '0' || value[0] == 'false'
        records
      else
        records.includes(:projects).where.not(projects: { id: nil })
      end
    }

    def custom_links(_)
      { self: nil }
    end

    def project_count
      projects.count
    end
  end
end
