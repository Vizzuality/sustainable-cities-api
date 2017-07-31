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

    filter :bme_id, apply: ->(records, value, _options) {
      records.joins(projects: :bmes).where('bmes.id = ?', value[0].to_i)
    }

    filter :bme_slug, apply: ->(records, value, _options) {
      records.joins(projects: :bmes).where('bmes.slug = ?', value[0])
    }

    def custom_links(_)
      { self: nil }
    end
  end
end
