# frozen_string_literal: true
class CreateProjectCities < ActiveRecord::Migration[5.1]
  def change
    create_table :project_cities do |t|
      t.integer :city_id,    index: true
      t.integer :project_id, index: true

      t.timestamps
    end
  end
end
