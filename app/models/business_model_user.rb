class BusinessModelUser < ApplicationRecord
  belongs_to :business_model
  belongs_to :user
end