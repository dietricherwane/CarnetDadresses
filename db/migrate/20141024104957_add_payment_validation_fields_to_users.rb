class AddPaymentValidationFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :validated_by, :integer
    add_column :users, :validated_at, :datetime
    add_column :users, :unpublished_by, :integer
    add_column :users, :unpublished_at, :datetime
  end
end
