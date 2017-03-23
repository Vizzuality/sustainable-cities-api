# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string
#  expires_at   :datetime
#  user_id      :integer
#  is_active    :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe APIKey, type: :model do
  it 'create a API KEY for webuser' do
    @user = create(:webuser)
    expect(@user.api_key.expired?).to eq(false)
  end

  it 'delete a API KEY for webuser' do
    @user = create(:webuser)
    @user.delete_api_key
    expect(@user.reload.api_key.present?).to eq(false)
  end

  it 'Deactivate a API KEY for webuser' do
    @user = create(:webuser)
    @user.api_key.deactivate
    expect(@user.reload.api_key.expired?).to eq(true)
  end
end
