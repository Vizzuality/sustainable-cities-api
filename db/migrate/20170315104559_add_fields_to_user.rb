# frozen_string_literal: true
class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role,                 :integer, default: 0
    add_column :users, :country_id,           :integer, index: true
    add_column :users, :city_id,              :integer, index: true
    add_column :users, :nickname,             :string,  unique: true
    add_column :users, :name,                 :string
    add_column :users, :institution,          :string
    add_column :users, :position,             :string
    add_column :users, :twitter_account,      :string
    add_column :users, :linkedin_account,     :string
    add_column :users, :is_active,            :boolean, default: true
    add_column :users, :deactivated_at,       :datetime
    add_column :users, :image,               :string
    add_column :users, :notifications_mailer, :boolean, default: true
  end
end
