module V1
  class BusinessModelBmeResource < JSONAPI::Resource
    has_one :comment, polymorphic: true, foreign_key: :id
    has_one :business_model
    has_one :bme
  end
end