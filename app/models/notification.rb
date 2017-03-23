# frozen_string_literal: true
# == Schema Information
#
# Table name: notifications
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  notificable_type :string
#  notificable_id   :integer
#  summary          :text
#  counter          :integer          default(1)
#  emailed_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Notification < ActiveRecord::Base
  belongs_to :user, inverse_of: :notifications, counter_cache: true
  belongs_to :notificable, polymorphic: true

  scope :unread,      -> { all                            }
  scope :recent,      -> { order('notifications.id DESC') }
  scope :not_emailed, -> { where(emailed_at: nil)         }
  scope :for_render,  -> { includes(:notificable)         }

  default_scope { recent }

  class << self
    def build(users, notificable, summary)
      notifications = []
      notifications_size = 1000
      users.each do |user_id|
        notifications << Notification.new(user_id: user_id, notificable: notificable, summary: build_summary(notificable, summary))
        if notifications.size >= notifications_size
          Notification.import notifications
          notifications = []
        end
      end
      Notification.import notifications
      rebuild_counters
    end

    def build_summary(notificable=nil, summary_action=nil)
      summary  = ''
      summary += "The #{notificable.model_name.human} " if notificable.present?
      summary += notificable_name(notificable)          if notificable.present?
      summary += ' '
      summary += summary_action
      summary
    end

    def notificable_name(notificable)
      notificable.try(:name)
    end

    def rebuild_counters
      ActiveRecord::Base.connection.execute <<-SQL
        UPDATE users SET notifications_count = (SELECT count(1)
                                                FROM notifications
                                                WHERE notifications.user_id = users.id)
      SQL
    end

    # On development
    # whenever --update-crontab --set environment='development'
    # if /bin/bash: shell_session_update: command not found please run:
    # rvm get head

    def daily_notifications_task
      user_ids = Notification.not_emailed.pluck(:user_id).uniq
      user_ids.each do |user_id|
        user = User.find(user_id)
        if user.notifications_mailer?
          user_name     = user.display_name
          user_email    = user.email
          summary_items = user.notifications.not_emailed
          NotificationMailer.daily_summary_email(user_name, user_email, summary_items.to_a).deliver_now
          mark_as_emailed(summary_items.pluck(:id))
        end
      end
    end

    def mark_as_emailed(ids)
      date_now = Time.now.to_formatted_s(:db)
      query = ActiveRecord::Base.send(:sanitize_sql_array, ["UPDATE notifications SET emailed_at = ?
                                                             WHERE notifications.id = ANY(ARRAY#{ids});", date_now])
      ActiveRecord::Base.connection.execute(query)
    end
  end

  def notificable_title
    self.summary
  end

  def notificable_group
    self.notificable.model_name.human if notificable.present?
  end

  def timestamp
    self.notificable.updated_at.to_formatted_s(:short) if notificable.present?
  end

  def mark_as_read
    self.destroy
  end
end
