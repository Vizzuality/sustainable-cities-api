module V1
  class ImpactResource < JSONAPI::Resource
    caching

    attributes :name, :description, :impact_value, :impact_unit, :is_active

    has_one :study_case
    has_one :category
    has_many :external_sources

    filters :id, :name, :impact_value, :impact_unit, :is_active

    def custom_links(_)
      { self: nil }
    end
  end
end