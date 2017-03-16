# == Schema Information
#
# Table name: documents
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

RSpec.describe Document, type: :model do
  before :each do
    @document = create(:document)
  end

  it 'Count on project' do
    expect(Document.count).to eq(1)
    expect(@document.attacheable.name).to eq('A Project')
  end
end
