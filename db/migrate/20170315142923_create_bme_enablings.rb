# frozen_string_literal: true
class CreateBmeEnablings < ActiveRecord::Migration[5.1]
  def change
    create_table :bme_enablings do |t|
      t.integer :bme_id,      index: true
      t.integer :enabling_id, index: true

      t.timestamps
    end
  end
end
