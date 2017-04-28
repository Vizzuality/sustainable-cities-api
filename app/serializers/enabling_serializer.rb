# frozen_string_literal: true
# == Schema Information
#
# Table name: enablings
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  assessment_value :integer          default("Success")
#  category_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  is_featured      :boolean          default(FALSE)
#

class EnablingSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :assessment_value, :is_featured

  belongs_to :category, serializer: CategorySerializer
  has_many   :bmes,     serializer: BmeSerializer
end
