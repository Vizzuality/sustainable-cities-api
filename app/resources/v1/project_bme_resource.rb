# frozen_string_literal: true
module V1
  class ProjectBmeResource < JSONAPI::Resource
    caching

    attributes :bme_id, :project_id, :description, :is_featured
    has_one :bme
    has_one :project

    def custom_links(_)
      { self: nil }
    end
  end
end
