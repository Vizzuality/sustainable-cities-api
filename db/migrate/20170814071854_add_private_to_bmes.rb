class AddPrivateToBmes < ActiveRecord::Migration[5.1]
  def change
    add_column :bmes, :private, :boolean, default: false
  end
end
