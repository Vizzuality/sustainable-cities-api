# frozen_string_literal: true
class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.references :commentable, polymorphic: true
      t.text       :body
      t.boolean    :is_active, default: false

      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type], name: 'comments_commentable_index'
  end
end
