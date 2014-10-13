class AddPublishedToCivilities < ActiveRecord::Migration
  def change
    add_column :civilities, :published, :boolean
  end
end
