# frozen_string_literal: true
# == Schema Information
#
# Table name: project_cities
#
#  id         :integer          not null, primary key
#  city_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectCity < ApplicationRecord
  belongs_to :project
  belongs_to :city
end
