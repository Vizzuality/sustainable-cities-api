# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  email                :string
#  password_digest      :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  role                 :integer          default("user")
#  country_id           :integer
#  city_id              :integer
#  nickname             :string
#  name                 :string
#  institution          :string
#  position             :string
#  twitter_account      :string
#  linkedin_account     :string
#  is_active            :boolean          default(TRUE)
#  deactivated_at       :datetime
#  image                :string
#  notifications_mailer :boolean          default(TRUE)
#  notifications_count  :integer          default(0)
#

class User < ApplicationRecord
  has_secure_password

  enum role: { user: 0, editor: 1, publisher: 2, admin: 3 }.freeze

  # Include default devise modules.
  TEMP_EMAIL_REGEX = /\Achange@tmp/

  mount_base64_uploader :image, AvatarUploader

  belongs_to :country, inverse_of: :users, optional: true
  belongs_to :city,    inverse_of: :users, optional: true

  has_one  :api_key
  has_many :notifications, inverse_of: :user, dependent: :destroy
  has_many :comments,      inverse_of: :user, dependent: :destroy
  has_many :project_users
  has_many :projects, through: :project_users

  after_destroy :remove_attachment_id_directory

  validates :nickname,    presence: true, uniqueness: { case_sensitive: false }
  validates_uniqueness_of :email
  validates_format_of     :email, without: TEMP_EMAIL_REGEX, on: :update
  validates :name,        presence: true
  validate  :validate_nickname

  validates_format_of :nickname, with: /\A[a-z0-9_\.][-a-z0-9]{1,19}\Z/i,
                                 exclusion: { in: %w(admin superuser about root publisher editor faq conntact user) },
                                 multiline: true

  validates :password, confirmation: true
  validates :password_confirmation, presence: true, on: :create

  include Activable
  include Roleable
  include Sanitizable

  scope :recent,          -> { order('users.updated_at DESC') }
  scope :by_nickname_asc, -> { order('users.nickname ASC')    }

  class << self
    def fetch_all(options)
      all
    end

    def user_select
      by_nickname_asc.map { |c| [c.nickname, c.id] }
    end
  end

  def permissions
    if self.is_active?
      role_class  = '::Permissions'
      role_class += "::#{self.role.classify}"

      role_class.constantize.send('abilities')
    else
      ::Permissions::Guest.abilities
    end
  end

  def display_name
    return "#{half_email}" if name.blank?
    "#{name}"
  end

  def active_for_authentication?
    super and self.is_active?
  end

  def inactive_message
    'You are not allowed to sign in.'
  end

  def api_key_exists?
    !self.api_key.expired? if self.api_key.present?
  end

  def regenerate_api_key
    token = Auth.issue({ user: id })
    if ::APIKey.where(user_id: id).first_or_create
      api_key.update(access_token: token, is_active: true, expires_at: DateTime.now + 1.year)
    end
  end

  def delete_api_key
    if self.api_key
      APIKey.where(user_id: self.id).delete_all
    end
  end

  private

    def remove_attachment_id_directory
      FileUtils.rm_rf(File.join('public', 'uploads', 'user', 'image', self.id.to_s)) if self.image
    end

    def validate_nickname
      if User.where(email: nickname).exists?
        errors.add(:nickname, :invalid)
      end
    end

    def half_email
      return "" if email.blank?
      index = email.index('@')
      return "" if index.nil? || index.to_i.zero?
      email[0, index.to_i]
    end
end
