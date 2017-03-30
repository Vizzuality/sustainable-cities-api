# == Schema Information
#
# Table name: external_sources
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  web_url          :string
#  source_type      :string
#  author           :string
#  publication_year :datetime
#  institution      :string
#  attacheable_type :string
#  attacheable_id   :integer
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe ExternalSource, type: :model do
  before :each do
    @external_source = create(:external_source)
  end

  it 'Count on external source' do
    expect(ExternalSource.count).to eq(1)
    expect(@external_source.attacheable.name).to eq('A Study case')
  end

  it 'Sanitize web url' do
    expect(@external_source.web_url).to eq('http://test-web.org')
  end
end
