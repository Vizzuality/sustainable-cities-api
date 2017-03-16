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

FactoryGirl.define do
  factory :country do
    sequence(:name) { |n| "#{n} Country #{Faker::Address.country}" }
    sequence(:iso)  { |n| "#{n}#{Faker::Address.country_code}" }
    region_name 'Australia/New Zealand'
    region_iso  'AZ'
    is_active true
    country_centroid '{ "type":"Point", "coordinates":[-25,135] }'
    region_centroid  '{ "type":"Point", "coordinates":[-26.3793465342288,135.977532183695] } }'
  end
end
