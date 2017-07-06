module V1
  class DocumentResource < JSONAPI::Resource
    caching

    attributes :name, :attachment, :is_active

    has_one :attacheable

    filters :id, :name, :is_active

    def custom_links(_)
      { self: nil }
    end
  end
end