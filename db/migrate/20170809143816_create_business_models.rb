class CreateBusinessModels < ActiveRecord::Migration[5.1]
  def change
    create_table :business_models do |t|
      t.string :title
      t.text :description
      t.integer :solution_id
      t.string :link_share
      t.string :link_edit

      t.timestamps
    end
  end
end
