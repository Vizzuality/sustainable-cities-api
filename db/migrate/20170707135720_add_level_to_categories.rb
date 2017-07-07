class AddLevelToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :level, :integer
  end
end
