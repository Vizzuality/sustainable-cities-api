class CreateBusinessModelsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :business_model_users do |t|
      t.integer :business_model_id
      t.integer :user_id
      t.boolean :is_owner, default: false
    end
  end
end
