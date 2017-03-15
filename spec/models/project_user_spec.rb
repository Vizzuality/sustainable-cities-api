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

require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
