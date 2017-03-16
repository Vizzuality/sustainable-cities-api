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
  before :each do
    @project = create(:project)
    @user    = create(:user, projects: [@project])
  end

  it 'Count on user project' do
    expect(@user.projects.count).to eq(1)
  end
end
