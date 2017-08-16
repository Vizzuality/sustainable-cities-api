module V1
  class BusinessModelUserResource < JSONAPI::Resource
    belongs_to :user
  end
end