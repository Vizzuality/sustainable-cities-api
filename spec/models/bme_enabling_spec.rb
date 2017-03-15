# == Schema Information
#
# Table name: bme_enablings
#
#  id          :integer          not null, primary key
#  bme_id      :integer
#  enabling_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe BmeEnabling, type: :model do
  before :each do
    @enabling = create(:enabling)
    @bme      = create(:bme, enablings: [@enabling])
  end

  it 'Count on bme enabling' do
    expect(@bme.enablings.count).to eq(1)
  end
end
