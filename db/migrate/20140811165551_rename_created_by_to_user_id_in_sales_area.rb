class RenameCreatedByToUserIdInSalesArea < ActiveRecord::Migration
  def change
    rename_column :sales_areas, :created_by, :user_id
  end
end
