# frozen_string_literal: true
class ChangeAttachedNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :attacheable_external_sources, :attached_id, :attacheable_id
    rename_column :attacheable_external_sources, :attached_type, :attacheable_type
  end
end
