# frozen_string_literal: true
class AddSlugToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :slug, :string
  end
end
