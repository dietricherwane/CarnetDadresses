class AddPublishedToFormations < ActiveRecord::Migration
  def change
    add_column :formations, :published, :boolean
  end
end
