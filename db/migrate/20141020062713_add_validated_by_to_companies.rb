class AddValidatedByToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :validated_by, :boolean
  end
end
