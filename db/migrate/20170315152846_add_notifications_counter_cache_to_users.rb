# frozen_string_literal: true
class AddNotificationsCounterCacheToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notifications_count, :integer, default: 0
  end
end
