# == Schema Information
#
# Table name: bmes
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tmp_bme_id  :integer
#  is_featured :boolean          default(FALSE)
#  slug        :string
#

require 'rails_helper'

RSpec.describe Bme, type: :model do
  before :each do
    FactoryGirl.create(:bme, name: 'Z Bme')
    @bme = create(:bme)
  end

  it 'Count on bme with default scope' do
    expect(Bme.count).to eq(2)
  end

  it 'Order by name asc' do
    expect(Bme.by_name_asc.first.name).to match('BME')
  end

  it 'Common and scientific name validation' do
    @bme = Bme.new(name: '')

    @bme.valid?
    expect { @bme.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'Fetch all bmes' do
    expect(Bme.fetch_all(nil).count).to eq(2)
  end
end
