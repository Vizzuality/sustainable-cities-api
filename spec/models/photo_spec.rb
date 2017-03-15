# == Schema Information
#
# Table name: photos
#
#  id               :integer          not null, primary key
#  name             :string
#  attachment       :string
#  attacheable_type :string
#  attacheable_id   :integer
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Photo, type: :model do
  before :each do
    @photo = create(:photo)
  end

  it 'Count on project' do
    expect(Photo.count).to eq(1)
    expect(@photo.attacheable.name).to eq('A Project')
  end
end
