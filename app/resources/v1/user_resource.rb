module V1
  class UserResource < JSONAPI::Resource
    caching
    attributes :name, :email, :role, :country_id,
               :city_id, :nickname, :institution, :position,
               :twitter_account, :linkedin_account, :is_active,
               :deactivated_at, :image, :permissions

    filters :id, :name, :email, :role, :country_id, :city_id, :nickname, :position, :is_active

    def permissions
      object.permissions
    end

    def custom_links(_)
      { self: nil }
    end
  end
end