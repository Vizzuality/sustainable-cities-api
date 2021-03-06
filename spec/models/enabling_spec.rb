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
#  is_featured      :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Enabling, type: :model do
  before :each do
    FactoryGirl.create(:enabling, name: 'Z Enabling')
    @category = create(:category, category_type: 'Enabling')
    @enabling = create(:enabling, category: @category)
  end

  it 'Count on enabling' do
    expect(Enabling.count).to eq(2)
  end

  it 'Order by name asc' do
    expect(Enabling.by_name_asc.first.name).to match('Enabling')
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
