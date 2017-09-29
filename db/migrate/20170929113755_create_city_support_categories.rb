class CreateCitySupportCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :city_support_categories do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
