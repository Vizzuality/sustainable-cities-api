# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  parent_id     :integer
#  category_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  label         :string
#

FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "#{n} Category #{Faker::Lorem.sentence}" }
    category_type 'Category'
  end
end
