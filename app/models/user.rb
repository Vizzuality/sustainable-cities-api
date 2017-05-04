# frozen_string_literal: true
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

class User < ApplicationRecord
  has_secure_password

  enum role: { user: 0, editor: 1, publisher: 2, admin: 3 }.freeze

  # Include default devise modules.
  TEMP_EMAIL_REGEX = /\Achange@tmp/

  mount_base64_uploader :image, AvatarUploader

  belongs_to :country, inverse_of: :users, optional: true
  belongs_to :city,    inverse_of: :users, optional: true

  has_one  :api_key
  has_many :comments, inverse_of: :user, dependent: :destroy
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

  validates :password, confirmation: true,
                       length: { within: 8..20 },
                       on: :create
  validates :password_confirmation, presence: true, on: :create

  include Activable
  include Roleable
  include Sanitizable

  scope :recent,          -> { order('users.updated_at DESC') }
  scope :by_nickname_asc, -> { order('users.nickname ASC')    }

  scope :filter_by_name_or_nickname, ->(search_term) { where('users.name ilike ? or users.nickname ilike ?', "%#{search_term}%", "%#{search_term}%") }

  class << self
    def fetch_all(options)
      search_term = options['search'] if options.present? && options['search'].present?

      users = all
      users = users.filter_by_name_or_nickname(search_term) if search_term.present?
      users
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
    "#{half_email}" if name.blank?
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

  def send_reset_password_instructions(options)
    reset_url  = options[:reset_url]
    reset_url += '?reset_password_token='
    reset_url += generate_reset_token(self)

    PasswordMailer.password_email(display_name, email, reset_url).deliver
  end

  def reset_password_by_token(options)
    if reset_password_sent_at.present? && DateTime.now <= reset_password_sent_at + 2.hours
      update(password: options[:password],
             password_confirmation: options[:password_confirmation],
             reset_password_sent_at: nil)
    else
      self.errors.add(:reset_password_token, 'link expired.')
      self
    end
  end

  def reset_password_by_current_user(options)
    if update(password: options[:password],
              password_confirmation: options[:password_confirmation])
      self
    else
      self.errors.add(:password, 'could not be updated!')
      self
    end
  end

  private

    def generate_reset_token(user)
      token = SecureRandom.uuid
      user.update(reset_password_token: token, reset_password_sent_at: DateTime.now)
      user.reset_password_token
    end

    def remove_attachment_id_directory
      FileUtils.rm_rf(File.join('public', 'uploads', 'user', 'image', self.id.to_s)) if self.image
    end

    def validate_nickname
      if User.where(email: nickname).exists?
        errors.add(:nickname, :invalid)
      end
    end

    def half_email
      '' if email.blank?
      index = email.index('@')
      '' if index.nil? || index.to_i.zero?
      email[0, index.to_i]
    end
end
