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

class ProjectBme < ApplicationRecord
  belongs_to :project
  belongs_to :bme
end
