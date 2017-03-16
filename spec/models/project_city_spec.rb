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

require 'rails_helper'

RSpec.describe ProjectCity, type: :model do
  before :each do
    @city    = create(:city)
    @project = create(:project, cities: [@city])
  end

  it 'Count on project city' do
    expect(@project.cities.count).to eq(1)
  end
end
