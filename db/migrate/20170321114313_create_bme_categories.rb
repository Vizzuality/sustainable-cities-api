# frozen_string_literal: true
class CreateBmeCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :bme_categories do |t|
      t.integer :bme_id,      index: true
      t.integer :category_id, index: true

      t.timestamps
    end
  end
end
