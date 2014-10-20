class AddCompanyIdToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :company_id, :integer
  end
end
