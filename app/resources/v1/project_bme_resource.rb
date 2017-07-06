module V1
  class ProjectBmeResource < JSONAPI::Resource
    caching

    attributes :bme_id, :project_id, :description
    has_one :bme
    has_one :project

    def custom_links(_)
      { self: nil }
    end
  end
end