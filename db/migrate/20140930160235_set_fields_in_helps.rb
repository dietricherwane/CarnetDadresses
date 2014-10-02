class SetFieldsInHelps < ActiveRecord::Migration
  def change
    remove_column :helps, :content
    remove_column :helps, :user_id
    
    add_column :helps, :website_content, :text
    add_column :helps, :website_user_id, :integer
    add_column :helps, :website_updated_at, :datetime
    add_column :helps, :wallet_content, :text
    add_column :helps, :wallet_user_id, :integer
    add_column :helps, :wallet_updated_at, :datetime
  end
end
