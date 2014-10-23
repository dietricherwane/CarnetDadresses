class RenameYearInFormations < ActiveRecord::Migration
  def change
    remove_column :formations, :year
    add_column :formations, :formation_year,:date
  end
end
