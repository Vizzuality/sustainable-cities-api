class AddOrderToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :order, :integer
  end
end
