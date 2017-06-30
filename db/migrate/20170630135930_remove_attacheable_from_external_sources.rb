class RemoveAttacheableFromExternalSources < ActiveRecord::Migration[5.1]
  def change
    remove_column :external_sources, :attacheable_id
    remove_column :external_sources, :attacheable_type
  end
end
