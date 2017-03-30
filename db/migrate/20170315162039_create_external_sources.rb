# frozen_string_literal: true
class CreateExternalSources < ActiveRecord::Migration[5.1]
  def change
    create_table :external_sources do |t|
      t.string     :name
      t.text       :description
      t.string     :web_url
      t.string     :source_type
      t.string     :author
      t.datetime   :publication_year
      t.string     :institution
      t.references :attacheable, polymorphic: true
      t.boolean    :is_active, default: false

      t.timestamps
    end

    add_index :external_sources, [:attacheable_id, :attacheable_type], name: 'external_sources_attacheable_index'
  end
end
