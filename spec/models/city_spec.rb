# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  country_id :integer
#  iso        :string
#  lat        :decimal(, )
#  lng        :decimal(, )
#  province   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe City, type: :model do
  context 'For user relations' do
    before :each do
      @city = create(:city)
      @user = create(:user, city: @city)
    end

    it 'Count on city' do
      expect(User.count).to       eq(1)
      expect(@city.users.size).to eq(1)
      expect(@user.city.name).to  match('Madrid')
    end

    it 'Fallbacks for empty translations on city' do
      expect(@user.city.name).to match('Madrid')
    end

    it 'Fetch all cities' do
      expect(City.fetch_all(nil).count).to eq(1)
    end

    it 'Select for active cities' do
      expect(City.city_select.count).to eq(1)
    end
  end
end
