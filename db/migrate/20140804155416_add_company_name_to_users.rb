class AddCompanyNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string, limit: 100
  end
end
