# == Schema Information
#
# Table name: countries
#
#  id               :integer          not null, primary key
#  name             :string
#  region_name      :string
#  iso              :string
#  region_iso       :string
#  country_centroid :jsonb
#  region_centroid  :jsonb
#  is_active        :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Country, type: :model do
  context 'For user relations' do
    before :each do
      @country = create(:country)
      @user    = create(:user, country: @country)
    end

    it 'Count on country' do
      expect(User.count).to          eq(1)
      expect(@country.users.size).to eq(1)
      expect(@user.country.name).to  match('Country')
    end

    it 'Fallbacks for empty translations on country' do
      expect(@user.country.name).to match('Country')
    end

    it 'Fetch all countries' do
      expect(Country.fetch_all(nil).count).to eq(1)
    end
  end
end
