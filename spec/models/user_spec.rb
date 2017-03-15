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

require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @user = create(:user, username: 'testuser')
  end

  it 'Users count' do
    expect(User.count).to eq(1)
  end

  it 'Deactivate activate user' do
    @user.deactivate
    expect(User.count).to                  eq(1)
    expect(User.filter_inactives.count).to eq(1)
    expect(@user.deactivated?).to          be(true)
    @user.activate
    expect(@user.activated?).to            be(true)
    expect(User.filter_actives.count).to   be(1)
  end

  it 'User name and username validation' do
    @user = User.new(name: '', username: '', email: 'user@example.com', password: 'password', password_confirmation: 'password')

    @user.valid?
    expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Username can't be blank, Username is invalid, Name can't be blank")
  end

  it 'Username is email validation' do
    @user = User.new(name: 'Test user', username: 'blabla@example.com', email: 'user@example.com', password: 'password', password_confirmation: 'password')

    @user.valid?
    expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Username is invalid')
  end

  it 'Username specific validation' do
    @user = User.new(name: 'Test user', username: 'admin 333', email: 'user@example.com', password: 'password', password_confirmation: 'password')

    @user.valid?
    expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Username is invalid')
  end

  it 'Username uniqueness validation' do
    @user = User.new(name: 'Test user', username: 'Testuser', email: 'user@example.com', password: 'password', password_confirmation: 'password')

    @user.valid?
    expect { @user.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Username has already been taken')
  end
end
