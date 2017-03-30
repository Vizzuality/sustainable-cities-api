# frozen_string_literal: true
# == Schema Information
#
# Table name: bmes
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tmp_bme_id  :integer
#

class BmeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  has_many :enablings,  serializer: EnablingSerializer
  has_many :categories, serializer: CategorySerializer
end
