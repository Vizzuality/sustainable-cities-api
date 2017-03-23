# frozen_string_literal: true
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

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user,        inverse_of: :comments

  validates :body, presence: true
  validates :user, presence: true

  validate :validate_body_length

  include Activable

  scope :recent,             -> { order('comments.id DESC')                 }
  scope :sort_by_created_at, -> { order('comments.sort_by_created_at DESC') }

  class << self
    def build(commentable, user, body)
      new commentable: commentable,
          user_id:     user.id,
          body:        body
    end

    def body_max_length
      1000
    end
  end

  private

    def validate_body_length
      validator = ActiveModel::Validations::LengthValidator.new(
        attributes: :body,
        maximum: Comment.body_max_length
      )
      validator.validate(self)
    end
end
