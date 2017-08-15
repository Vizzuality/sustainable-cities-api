# frozen_string_literal: true
module V1
  class BusinessModelsEditResource < JSONAPI::Resource
    model_name 'BusinessModel'
    caching

    attributes :title, :description, :link_share, :link_edit, :solution_id

    belongs_to :owner

    has_one :solution
    has_many :business_model_bmes
    has_many :bmes
    has_many :business_model_enablings
    has_many :enablings
    has_many :business_model_users
    has_many :users
  end
end
