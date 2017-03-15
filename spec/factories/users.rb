# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default("user")
#  country_id             :integer
#  city_id                :integer
#  username               :string
#  name                   :string
#  institution            :string
#  position               :string
#  twitter_account        :string
#  linkedin_account       :string
#  is_active              :boolean          default(TRUE)
#  deactivated_at         :datetime
#  avatar                 :string
#  notifications_mailer   :boolean          default(TRUE)
#  notifications_count    :integer          default(0)
#

FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "pepe#{n}@vizzuality.com" }
    sequence(:username) { |n| "pepe#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Test user'
    confirmed_at Time.now
  end

  factory :editor, class: User do
    sequence(:email)    { |n| "editor#{n}@vizzuality.com" }
    sequence(:username) { |n| "editor#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Editor user'
    role 1
    confirmed_at Time.now
  end

  factory :publisher, class: User do
    sequence(:email)    { |n| "publisher#{n}@vizzuality.com" }
    sequence(:username) { |n| "publisher#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Publisher user'
    role 2
    confirmed_at Time.now
  end

  factory :admin, class: User do
    sequence(:email)    { |n| "admin#{n}@vizzuality.com" }
    sequence(:username) { |n| "admin#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Admin user'
    role 3
    confirmed_at Time.now
  end
end
