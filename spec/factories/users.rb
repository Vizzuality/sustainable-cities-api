# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  password_digest        :string
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
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#

FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "pepe#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "pepe#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Test user'
    role 'user'
    is_active true
  end

  factory :editor, class: User do
    sequence(:email)    { |n| "editor#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "editor#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Editor user'
    role 'editor'
    is_active true
  end

  factory :publisher, class: User do
    sequence(:email)    { |n| "publisher#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "publisher#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Publisher user'
    role 'publisher'
    is_active true
  end

  factory :admin, class: User do
    sequence(:email)    { |n| "admin#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "admin#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Admin user'
    role 'admin'
    is_active true
  end

  factory :webuser, class: User do
    sequence(:email)    { |n| "webuser#{n}@vizzuality.com" }
    sequence(:nickname) { |n| "webuser#{n}"                }

    password 'password'
    password_confirmation { |u| u.password }
    name 'Web user'
    is_active true
    role 'user'

    after(:create) do |user|
      user.regenerate_api_key
    end
  end
end
