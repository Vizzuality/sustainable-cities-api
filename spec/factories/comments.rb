# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_type :string
#  commentable_id   :integer
#  body             :text
#  is_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "#{n} Comment #{Faker::Address.country}" }
    is_active true
  end
end
