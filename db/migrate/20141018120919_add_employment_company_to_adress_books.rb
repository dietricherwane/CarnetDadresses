class AddEmploymentCompanyToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :employment_company, :string
  end
end
