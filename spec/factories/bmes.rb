# == Schema Information
#
# Table name: bmes
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tmp_bme_id  :integer
#  is_featured :boolean          default(FALSE)
#  slug        :string
#

FactoryGirl.define do
  factory :bme do
    sequence(:name) { |n| "#{n} BME #{Faker::Lorem.sentence}" }
  end
end
