class AddPublishedToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :published, :boolean
  end
end
