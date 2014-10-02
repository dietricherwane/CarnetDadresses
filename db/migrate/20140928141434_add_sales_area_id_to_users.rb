class AddSalesAreaIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sales_area_id, :integer
  end
end
