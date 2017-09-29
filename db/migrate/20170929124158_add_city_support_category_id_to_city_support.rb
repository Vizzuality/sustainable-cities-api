class AddCitySupportCategoryIdToCitySupport < ActiveRecord::Migration[5.1]
  def change
    add_column :city_supports, :city_support_category_id, :integer
  end
end
