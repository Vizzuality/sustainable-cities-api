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
  accepts_nested_attributes_for :bme

  has_one :comment, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comment
end
