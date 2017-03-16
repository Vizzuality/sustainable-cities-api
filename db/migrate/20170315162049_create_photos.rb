# frozen_string_literal: true
class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.string     :name
      t.string     :attachment
      t.references :attacheable, polymorphic: true
      t.boolean    :is_active, default: false

      t.timestamps
    end

    add_index :photos, [:attacheable_id, :attacheable_type], name: 'photos_attacheable_index'
  end
end
