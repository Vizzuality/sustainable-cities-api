module V1
  class ExternalSourceResource < JSONAPI::Resource
    caching

    attributes :name, :description, :web_url, :source_type, :author, :publication_year, :institution, :is_active

    has_many :projects
    has_many :impacts
    has_many :bmes
    filters :id, :name, :source_type, :author, :publication_year, :institution, :is_active

    def custom_links(_)
      { self: nil }
    end
  end
end