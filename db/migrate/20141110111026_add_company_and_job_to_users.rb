class AddCompanyAndJobToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company, :string
    add_column :users, :job, :string
  end
end
