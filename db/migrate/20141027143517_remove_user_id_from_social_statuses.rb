class RemoveUserIdFromSocialStatuses < ActiveRecord::Migration
  def change
    remove_column :social_statuses, :user_id
  end
end
