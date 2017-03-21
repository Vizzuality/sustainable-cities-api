# == Schema Information
#
# Table name: bme_categories
#
#  id          :integer          not null, primary key
#  bme_id      :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe BmeCategory, type: :model do
  before :each do
    @bme_category = create(:category, category_type: 'Bme')
    @bme_timing   = create(:category, name: 'Bme Timing', category_type: 'Timing')
    @bme          = create(:bme, categories: [@bme_category, @bme_timing])
  end

  it 'Count on bme category' do
    expect(@bme.categories.count).to eq(2)
  end

  it 'Count on category bme' do
    expect(@bme_timing.bmes.count).to eq(1)
  end
end
