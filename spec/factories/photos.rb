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

FactoryGirl.define do
  factory :photo do
    name 'Photo'
    attachment { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files', 'image.jpg')) }
    association :attacheable, factory: :project
  end
end
