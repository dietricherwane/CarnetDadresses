class AddUserIdToHoldings < ActiveRecord::Migration
  def change
    add_column :holdings, :user_id, :integer
  end
end
