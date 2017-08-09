class CreateBusinessModelsEnablings < ActiveRecord::Migration[5.1]
  def change
    create_table :business_model_enablings do |t|
      t.integer :business_model_id
      t.integer :enabling_id
    end
  end
end
