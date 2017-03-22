# frozen_string_literal: true
class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string     :name
      t.text       :situation
      t.text       :solution
      t.references :category, index: true, foreign_key: true
      t.integer    :country_id
      t.integer    :city_id
      t.datetime   :operational_year
      t.integer    :project_type
      t.boolean    :is_active, default: false
      t.datetime   :deactivated_at
      t.boolean    :publish_request, default: false
      t.datetime   :published_at

      t.timestamps
    end
  end
end
