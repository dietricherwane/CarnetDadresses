class AddActivitiesToAdressBooks < ActiveRecord::Migration
  def change
    add_column :adress_books, :activities, :text
  end
end
