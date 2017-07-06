module V1
  class ProjectResource < JSONAPI::Resource
    caching

    attributes :name, :situation, :solution, :category_id, :solution_id, :solution_slug, :solution_name, :country_id,
               :operational_year, :project_type, :is_active, :is_featured,
               :deactivated_at, :publish_request, :published_at, :bme_tree

    filters :id, :name, :situation, :solution_id, :category_id, :country_id,
            :operational_year, :project_type, :is_active, :is_featured, :published_at

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

    def solution_id
      object.category.parent.id rescue nil
    end

    def solution_slug
      object.category.parent.slug rescue nil
    end

    def solution_name
      object.category.parent.name rescue nil
    end


    def custom_links(_)
      { self: nil }
    end
  end
end