class AddJobRoleToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :job_role, :string
  end
end
