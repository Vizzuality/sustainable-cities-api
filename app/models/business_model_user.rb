# == Schema Information
#
# Table name: business_model_users
#
#  id                :integer          not null, primary key
#  business_model_id :integer
#  user_id           :integer
#  is_owner          :boolean          default(FALSE)
#

class BusinessModelUser < ApplicationRecord
  belongs_to :business_model
  belongs_to :user
end
