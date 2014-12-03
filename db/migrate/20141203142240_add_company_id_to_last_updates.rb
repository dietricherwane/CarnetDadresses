class AddCompanyIdToLastUpdates < ActiveRecord::Migration
  def change
    add_column :last_updates, :company_id, :integer
  end
end
