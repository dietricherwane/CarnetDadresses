class AddUserIdToFormations < ActiveRecord::Migration
  def change
    add_column :formations, :user_id, :integer
  end
end
