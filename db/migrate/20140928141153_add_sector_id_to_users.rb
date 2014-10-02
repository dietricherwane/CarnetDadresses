class AddSectorIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sector_id, :integer
  end
end
