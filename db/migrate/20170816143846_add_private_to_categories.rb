class AddPrivateToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :private, :boolean, default: false
  end
end
