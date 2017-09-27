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
#  label         :string
#  slug          :string
#  level         :integer
#  private       :boolean          default(FALSE)
#  order         :integer
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  before :each do
    FactoryGirl.create(:category, name: 'Z Category', category_type: 'Category')
    @category = create(:category, category_type: 'Category')
  end

  it 'Count on category' do
    expect(Category.count).to eq(2)
  end

  it 'Order by name asc' do
    expect(Category.by_name_asc.first.name).to match('Category')
  end

  it 'Common and scientific name validation' do
    @category = Category.new(name: '', category_type: 'Category')

    @category.valid?
    expect { @category.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it 'Fetch all categories' do
    expect(Category.fetch_all(nil).count).to eq(2)
  end
end
