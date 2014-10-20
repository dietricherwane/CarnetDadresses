class AddSalesAreaIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :sales_area_id, :integer
  end
end
