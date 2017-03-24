# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  name              :string
#  situation         :text
#  solution          :text
#  category_id       :integer
#  country_id        :integer
#  operational_year  :datetime
#  project_type      :integer
#  is_active         :boolean          default(FALSE)
#  deactivated_at    :datetime
#  publish_request   :boolean          default(FALSE)
#  published_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  tmp_study_case_id :integer
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  before :each do
    FactoryGirl.create(:business_model)
    FactoryGirl.create(:study_case)
    @category   = create(:category,   name: 'Study case category')
    @study_case = create(:study_case, name: 'Study case', category: @category, impacts: [FactoryGirl.create(:impact, name: 'Z Impact')])
  end

  it 'Count on study_case with default scope' do
    expect(Project.count).to                  eq(3)
    expect(Project.all.second.name).to        eq('A Study case')
    expect(Project.by_study_case.size).to     eq(2)
    expect(Project.by_business_model.size).to eq(1)
  end

  it 'Check for relations' do
    expect(@study_case.impacts.first.name).to eq('Z Impact')
    expect(@study_case.category.name).to      eq('Study case category')
  end

  it 'Order by name asc' do
    expect(Project.by_name_asc.first.name).to eq('A Business model')
  end

  it 'Common and scientific name validation' do
    @study_case = Project.new(name: '')

    @study_case.valid?
    expect { @study_case.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'Fetch all study_cases' do
    expect(Project.fetch_all(nil).count).to eq(3)
  end
end
