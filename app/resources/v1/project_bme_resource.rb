module V1
  class ProjectBmeResource < JSONAPI::Resource
    caching

    #attributes :name, :iso, :description
    #has_many :country_sectors
    #has_many :groups
    #filters :id, :name, :iso

    def custom_links(_)
      { self: nil }
    end
  end
end