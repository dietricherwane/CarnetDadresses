class RemoveUnusedFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :social_status_id
    remove_column :users, :trading_identifier
    remove_column :users, :company_name
    remove_column :users, :sector_id
    remove_column :users, :sales_area_id
    remove_column :users, :shortcut
    remove_column :users, :comment
    remove_column :users, :logo
    remove_column :users, :role
  end
end
