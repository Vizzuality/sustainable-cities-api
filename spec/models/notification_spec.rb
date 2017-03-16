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

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Unread (scope)' do
    it 'returns only unread notifications' do
      FactoryGirl.create(:notification)
      project = create(:project)
      FactoryGirl.create(:notification, notificable: project)
      expect(Notification.unread.size).to eq(2)
    end
  end

  describe 'Recent (scope)' do
    it 'returns notifications sorted by id descendant' do
      project          = create(:project)
      old_notification = create(:notification)
      new_notification = create(:notification, notificable: project)

      sorted_notifications = Notification.recent
      expect(sorted_notifications.size).to  eq(2)
      expect(sorted_notifications.first).to eq(new_notification)
      expect(sorted_notifications.last).to  eq(old_notification)
    end
  end

  describe 'For_render (scope)' do
    it 'returns notifications including notificable and user' do
      expect(Notification).to receive(:includes).with(:notificable).exactly(:once)
      Notification.for_render
    end
  end

  describe 'Timestamp' do
    it 'returns the timestamp of the trackable object' do
      project      = create(:project)
      notification = create(:notification, notificable: project)

      expect(notification.timestamp).to eq(project.updated_at.to_formatted_s(:short))
    end
  end

  describe 'Mark_as_read' do
    it 'destroys notification' do
      notification = create(:notification)
      expect(Notification.unread.size).to eq 1

      notification.mark_as_read
      expect(Notification.unread.size).to eq 0
    end
  end

  describe 'Daily_notifications_task' do
    it 'email notification' do
      notification = create(:notification)
      expect(Notification.unread.size).to eq 1

      Notification.daily_notifications_task
      expect(notification.reload.emailed_at.to_date).to eq(Time.now.to_date)
    end
  end

  describe 'Build notification' do
    it 'Notification on project' do
      user    = create(:editor)
      project = create(:study_case)
      Notification.build([user.id], project, 'Lorem ipsum..')
      notification = Notification.last

      expect(notification.user_id).to          eq(user.id)
      expect(notification.notificable_type).to eq('Project')
      expect(project.notifications.size).to    eq(1)
      expect(user.reload.notifications_count).to      eq(1)
    end
  end
end
