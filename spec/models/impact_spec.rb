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

require 'rails_helper'

RSpec.describe Impact, type: :model do
  before :each do
    FactoryGirl.create(:impact, name: 'Z Impact')
    @study_case = create(:project, name: 'Study case')
    @category   = create(:category, name: 'Study case category', category_type: 'Impact')
    @impact     = create(:impact, category: @category, study_case: @study_case)
  end

  it 'Count on impact with default scope' do
    expect(Impact.count).to           eq(2)
    expect(Impact.all.second.name).to eq('Z Impact')
  end

  it 'Check for relations' do
    expect(@impact.study_case.name).to eq('Study case')
    expect(@impact.category.name).to   eq('Study case category')
  end

  it 'Order by name asc' do
    expect(Impact.by_name_asc.first.name).to eq('A Impact')
  end

  it 'Common and scientific impact_value validation' do
    @impact = Impact.new(impact_value: '')

    @impact.valid?
    expect { @impact.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Impact value can't be blank")
  end

  it 'Fetch all impacts' do
    expect(Impact.fetch_all(nil).count).to eq(2)
  end
end
