class ChangeTaglineToString < ActiveRecord::Migration[5.1]
  def change
    change_column(:projects, :tagline, :string)
  end
end
