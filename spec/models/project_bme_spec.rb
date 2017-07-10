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

require 'rails_helper'

RSpec.describe ProjectBme, type: :model do
  before :each do
    @bme     = create(:bme)
    @project = create(:project, bmes: [@bme])
  end

  it 'Count on project bme' do
    expect(@project.bmes.count).to eq(1)
  end
end
