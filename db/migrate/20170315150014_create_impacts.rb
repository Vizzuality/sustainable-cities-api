# frozen_string_literal: true
class CreateImpacts < ActiveRecord::Migration[5.1]
  def change
    create_table :impacts do |t|
      t.string     :name
      t.text       :description
      t.string     :impact_value
      t.string     :impact_unit
      t.references :project,    index: true, foreign_key: true
      t.references :category,   index: true, foreign_key: true
      t.boolean    :is_active,  default: false

      t.timestamps
    end
  end
end
