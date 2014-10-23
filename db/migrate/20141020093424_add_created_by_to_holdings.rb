class AddCreatedByToHoldings < ActiveRecord::Migration
  def change
    add_column :holdings, :created_by, :integer
    
    add_column :holdings, :validated_by, :integer
  end
end
