class AddUniquenessToBusinessModelEnablingsJoinTable < ActiveRecord::Migration[5.1]
  def change
    add_index :business_model_enablings, [ :enabling_id, :business_model_id ], unique: true, name: 'bm_enabling_index'
  end
end
