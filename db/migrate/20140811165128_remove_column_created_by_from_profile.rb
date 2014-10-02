class RemoveColumnCreatedByFromProfile < ActiveRecord::Migration
  def change
    remove_column :profiles, :created_by
  end
end
