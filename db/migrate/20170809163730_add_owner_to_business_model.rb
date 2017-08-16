class AddOwnerToBusinessModel < ActiveRecord::Migration[5.1]
  def change
    add_column :business_models, :owner_id, :integer
  end
end
