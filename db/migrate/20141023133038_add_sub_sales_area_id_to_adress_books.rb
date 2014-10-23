class AddSubSalesAreaIdToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :sub_sales_area_id, :integer
  end
end
