# frozen_string_literal: true
# == Schema Information
#
# Table name: project_bmes
#
#  id          :integer          not null, primary key
#  bme_id      :integer
#  project_id  :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_featured :boolean
#

class ProjectBmeSerializer < ActiveModel::Serializer
  attributes :description, :is_featured

  belongs_to :bme, serializer: BmeSerializer
  belongs_to :project, serializer: ProjectSerializer
end
