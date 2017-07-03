# frozen_string_literal: true
class RemoveAttacheableFromExternalSources < ActiveRecord::Migration[5.1]
  def change
    remove_column :external_sources, :attacheable_id, :integer
    remove_column :external_sources, :attacheable_type, :string
  end
end
