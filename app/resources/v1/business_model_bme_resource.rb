module V1
  class BusinessModelBmeResource < JSONAPI::Resource
    has_one :comment, polymorphic: true, foreign_key: :id
  end
end