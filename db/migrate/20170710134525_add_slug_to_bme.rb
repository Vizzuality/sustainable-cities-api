# frozen_string_literal: true
class AddSlugToBme < ActiveRecord::Migration[5.1]
  def change
    add_column :bmes, :slug, :string
  end
end
