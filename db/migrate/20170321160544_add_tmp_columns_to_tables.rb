# frozen_string_literal: true
class AddTmpColumnsToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :bmes, :tmp_bme_id,            :integer
    add_column :projects, :tmp_study_case_id, :integer
  end
end
