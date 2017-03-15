# frozen_string_literal: true
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

class User < ApplicationRecord
  enum role: { user: 0, editor: 1, publisher: 2, admin: 3 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :omniauthable, omniauth_providers: [:linkedin, :google_oauth2, :facebook]

  attr_accessor :login

  TEMP_EMAIL_PREFIX = 'change@tmp'
  TEMP_EMAIL_REGEX = /\Achange@tmp/

  mount_uploader :avatar, AvatarUploader

  belongs_to :country, inverse_of: :users, optional: true
  belongs_to :city,    inverse_of: :users, optional: true

  has_many :identities, dependent: :destroy
  has_many :notifications

  validates :username,    presence: true, uniqueness: { case_sensitive: false }
  validates_uniqueness_of :email
  validates_format_of     :email, without: TEMP_EMAIL_REGEX, on: :update
  validates :name,        presence: true
  validate  :validate_username

  validates_format_of :username, with: /\A[a-z0-9_\.][-a-z0-9]{1,19}\Z/i,
                                 exclusion: { in: %w(admin superuser about root publisher editor faq conntact user) },
                                 multiline: true

  include Activable
  include Roleable
  include Sanitizable

  scope :recent,          -> { order('updated_at DESC')    }
  scope :by_username_asc, -> { order('users.username ASC') }

  class << self
    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
      else
        if conditions[:username].nil?
          where(conditions).first
        else
          where(username: conditions[:username]).first
        end
      end
    end

    def user_select
      by_username_asc.map { |c| [c.username, c.id] }
    end

    def for_oauth(auth, signed_in_resource = nil)
      identity = Identity.for_oauth(auth)
      user     = signed_in_resource ? signed_in_resource : identity.user

      if user.nil?
        email    = auth.info.email
        name_atr = "#{auth.info.first_name} #{auth.info.last_name}"
        user     = User.where(email: email).first if email

        update_attr(user, name_atr, auth) if user

        if user.nil?
          user = User.new(
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20],
            name: name_atr
          )
          user.skip_confirmation!
          user.save!
        end
      end

      if identity.user != user
        identity.user = user
        identity.save!
      end

      user
    end

    def update_attr(user, name_atr, auth)
      update_attr = {}
      update_attr['name'] = name_atr if user.name.blank?
      update_attr
      user.update(update_attr)
    end
  end

  def display_name
    return "#{half_email}" if name.blank?
    "#{name}"
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end

  def active_for_authentication?
    super and self.is_active?
  end

  def inactive_message
    'You are not allowed to sign in.'
  end

  private

    def validate_username
      if User.where(email: username).exists?
        errors.add(:username, :invalid)
      end
    end

    def half_email
      return "" if email.blank?
      index = email.index('@')
      return "" if index.nil? || index.to_i.zero?
      email[0, index.to_i]
    end
end
