module V1
  class BusinessModelBmeResource < JSONAPI::Resource
    has_one :comment, polymorphic: true, foreign_key: :id
    has_one :bme
    has_one :business_model
  end
end