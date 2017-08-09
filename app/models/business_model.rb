class BusinessModel < ApplicationRecord
  has_many :business_model_bmes
  has_many :bmes, through: :business_models_bmes

  has_many :business_model_enablings
  has_many :enablings, through: :business_models_enablings

  # has_many :business_model_users
  # has_one :owner, , through: :business_model_users, 
  # has_many :contributors, through: :business_model_users
  # has_many :users, -> { where("id IN (?)", user.community_ids) }, through: :business_model_users
end
