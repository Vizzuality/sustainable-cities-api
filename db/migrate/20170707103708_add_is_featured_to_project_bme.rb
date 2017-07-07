class AddIsFeaturedToProjectBme < ActiveRecord::Migration[5.1]
  def change
    add_column :project_bmes, :is_featured, :boolean
  end
end
