class RemoveColumnsFromAdressBooks < ActiveRecord::Migration
  def change
    remove_column :adress_books, :trading_identifier
    remove_column :adress_books, :mobile_number
    remove_column :adress_books, :sales_area_id
    remove_column :adress_books, :hobbies
    remove_column :adress_books, :company_shortcut
    remove_column :adress_books, :capital
    remove_column :adress_books, :employees_amount
    remove_column :adress_books, :turnover
    remove_column :adress_books, :holding_id
    remove_column :adress_books, :activities
    remove_column :adress_books, :fax
    remove_column :adress_books, :website
  end
end
