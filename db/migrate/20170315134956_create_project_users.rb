# frozen_string_literal: true
class CreateProjectUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :project_users do |t|
      t.integer :user_id,    index: true
      t.integer :project_id, index: true
      t.boolean :is_owner,   default: false

      t.timestamps
    end
  end
end
