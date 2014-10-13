class AddCapitalAndEmployeesAmountAndTurnoverToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :capital, :float
    add_column :adress_books, :employees_amount, :integer
    add_column :adress_books, :turnover, :float
  end
end
