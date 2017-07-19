# frozen_string_literal: true
class AddTaglineToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :tagline, :text
  end
end
