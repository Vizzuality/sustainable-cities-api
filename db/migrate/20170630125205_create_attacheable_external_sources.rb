# frozen_string_literal: true
class CreateAttacheableExternalSources < ActiveRecord::Migration[5.1]
  def change
    create_table :attacheable_external_sources do |t|
      t.integer :external_source_id
      t.integer :attached_id
      t.string :attached_type
    end

    ExternalSource.all.each do |source|
      AttacheableExternalSource.create(external_source_id: source.id, attached_id: source.attacheable_id, attached_type: source.attacheable_type)
    end
  end
end
