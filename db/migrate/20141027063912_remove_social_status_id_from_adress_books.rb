class RemoveSocialStatusIdFromAdressBooks < ActiveRecord::Migration
  def change
    remove_column :adress_books, :social_status_id
  end
end
