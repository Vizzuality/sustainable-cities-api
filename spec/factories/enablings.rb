# == Schema Information
#
# Table name: enablings
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  assessment_value :integer          default("Success")
#  category_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :enabling do
    sequence(:name) { |n| "#{n} Enabling #{Faker::Lorem.sentence}" }
  end
end
