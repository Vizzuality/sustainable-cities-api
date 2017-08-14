class AddForeignKeyCountryToProjects < ActiveRecord::Migration[5.1]
  def change
    add_index :projects, :country_id
  end
end
