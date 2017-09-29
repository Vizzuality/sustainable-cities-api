class AddImageSourceToCitySupport < ActiveRecord::Migration[5.1]
  def change
    add_column :city_supports, :image_source, :string
  end
end
