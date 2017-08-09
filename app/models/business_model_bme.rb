# == Schema Information
#
# Table name: business_model_bmes
#
#  id                :integer          not null, primary key
#  business_model_id :integer
#  bme_id            :integer
#

class BusinessModelBme < ApplicationRecord
  belongs_to :business_model
  belongs_to :bme
end
