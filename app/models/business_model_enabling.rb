# == Schema Information
#
# Table name: business_model_enablings
#
#  id                :integer          not null, primary key
#  business_model_id :integer
#  enabling_id       :integer
#

class BusinessModelEnabling < ApplicationRecord
  belongs_to :business_model
  belongs_to :enabling
end
