class AddUniquenessToBusinesModelBmeJoinTable < ActiveRecord::Migration[5.1]
  def change
    add_index :business_model_bmes, [ :bme_id, :business_model_id ], unique: true, name: 'bme_bme_index'
  end
end
