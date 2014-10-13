class AddPublishedToHoldings < ActiveRecord::Migration
  def change
    add_column :holdings, :published, :boolean
  end
end
