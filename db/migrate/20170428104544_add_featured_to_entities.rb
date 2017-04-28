# frozen_string_literal: true
class AddFeaturedToEntities < ActiveRecord::Migration[5.1]
  def change
    add_column :projects,  :is_featured, :boolean, default: false
    add_column :bmes,      :is_featured, :boolean, default: false
    add_column :enablings, :is_featured, :boolean, default: false
    add_column :cities,    :is_featured, :boolean, default: false
  end
end
