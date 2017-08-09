class CreateBusinessModelsBmes < ActiveRecord::Migration[5.1]
  def change
    create_table :business_model_bmes do |t|
      t.integer :business_model_id
      t.integer :bme_id
    end
  end
end
