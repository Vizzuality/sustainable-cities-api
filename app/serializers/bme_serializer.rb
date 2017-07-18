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
#  is_featured :boolean          default(FALSE)
#

class BmeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :is_featured, :slug

  has_many :enablings,  serializer: EnablingSerializer
  has_many :categories, serializer: CategorySerializer
  has_many :external_sources, serializer: ExternalSourceSerializer

end
