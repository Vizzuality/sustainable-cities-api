# frozen_string_literal: true
# == Schema Information
#
# Table name: impacts
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :text
#  impact_value :string
#  impact_unit  :string
#  project_id   :integer
#  category_id  :integer
#  is_active    :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ImpactSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :impact_value, :impact_unit, :is_active

  belongs_to :study_case, serializer: ProjectSerializer
  belongs_to :category,   serializer: CategorySerializer
end
