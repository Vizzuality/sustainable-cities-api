# frozen_string_literal: true
# == Schema Information
#
# Table name: project_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  is_owner   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user
end
