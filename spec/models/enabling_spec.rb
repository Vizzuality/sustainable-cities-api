# == Schema Information
#
# Table name: enablings
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  assessment_value :integer          default("Success")
#  category_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Enabling, type: :model do
  before :each do
    FactoryGirl.create(:enabling, name: 'Z Enabling')
    @category = create(:category)
    @enabling = create(:enabling, category: @category)
  end

  it 'Count on enabling with default scope' do
    expect(Enabling.count).to           eq(2)
    expect(Enabling.all.second.name).to eq('Z Enabling')
  end

  it 'Order by name asc' do
    expect(Enabling.by_name_asc.first.name).to eq('A Enabling')
  end

  it 'Common and scientific name validation' do
    @enabling = Enabling.new(name: '')

    @enabling.valid?
    expect { @enabling.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'Fetch all enablings' do
    expect(Enabling.fetch_all(nil).count).to eq(2)
  end
end
