# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  parent_id     :integer
#  category_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  before :each do
    FactoryGirl.create(:category, name: 'Z Category')
    @category = create(:category)
  end

  it 'Count on category with default scope' do
    expect(Category.count).to           eq(2)
    expect(Category.all.second.name).to eq('Z Category')
  end

  it 'Order by name asc' do
    expect(Category.by_name_asc.first.name).to eq('A Category')
  end

  it 'Common and scientific name validation' do
    @category = Category.new(name: '')

    @category.valid?
    expect { @category.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'Fetch all categories' do
    expect(Category.fetch_all(nil).count).to eq(2)
  end
end
