# frozen_string_literal: true
class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string  :name
      t.text    :description
      t.integer :parent_id
      t.string  :category_type

      t.timestamps
    end
  end
end
