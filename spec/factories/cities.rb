# == Schema Information
#
# Table name: cities
#
#  id          :integer          not null, primary key
#  name        :string
#  country_id  :integer
#  iso         :string
#  lat         :decimal(, )
#  lng         :decimal(, )
#  province    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_featured :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :city do
    sequence(:name) { |n| "#{n} Madrid #{Faker::Address.city}" }
    association :country, factory: :country
  end
end
