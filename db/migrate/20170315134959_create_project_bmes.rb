# frozen_string_literal: true
class CreateProjectBmes < ActiveRecord::Migration[5.1]
  def change
    create_table :project_bmes do |t|
      t.integer :bme_id,     index: true
      t.integer :project_id, index: true

      t.timestamps
    end
  end
end
