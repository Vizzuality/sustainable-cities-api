# frozen_string_literal: true
class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.string     :name
      t.string     :attachment
      t.references :attacheable, polymorphic: true
      t.boolean    :is_active, default: false

      t.timestamps
    end

    add_index :documents, [:attacheable_id, :attacheable_type], name: 'documents_attacheable_index'
  end
end
