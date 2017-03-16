# frozen_string_literal: true
# == Schema Information
#
# Table name: project_bmes
#
#  id         :integer          not null, primary key
#  bme_id     :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectBme < ApplicationRecord
  belongs_to :project
  belongs_to :bme
end
