# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  email                  :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default("user")
#  country_id             :integer
#  city_id                :integer
#  nickname               :string
#  name                   :string
#  institution            :string
#  position               :string
#  twitter_account        :string
#  linkedin_account       :string
#  is_active              :boolean          default(TRUE)
#  deactivated_at         :datetime
#  image                  :string
#  notifications_mailer   :boolean          default(TRUE)
#  notifications_count    :integer          default(0)
#

FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "pepe#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "pepe#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Test user'
    confirmed_at Time.now
  end

  factory :editor, class: User do
    sequence(:email)    { |n| "editor#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "editor#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Editor user'
    role 1
    confirmed_at Time.now
  end

  factory :publisher, class: User do
    sequence(:email)    { |n| "publisher#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "publisher#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Publisher user'
    role 2
    confirmed_at Time.now
  end

  factory :admin, class: User do
    sequence(:email)    { |n| "admin#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "admin#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Admin user'
    role 3
    confirmed_at Time.now
  end
end
