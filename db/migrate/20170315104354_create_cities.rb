# frozen_string_literal: true
class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string     :name
      t.references :country, index: true, foreign_key: true
      t.string     :iso
      t.decimal    :lat
      t.decimal    :lng
      t.string     :province

      t.timestamps
    end
  end
end
