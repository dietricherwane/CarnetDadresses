class CreateForumThemes < ActiveRecord::Migration
  def change
    create_table :forum_themes do |t|
      t.string :title
      t.integer :sector_id
      t.integer :sales_area_id
      t.boolean :published
      t.integer :validated_by
      t.datetime :validated_at
      t.integer :unpublished_by
      t.datetime :unpublished_at

      t.timestamps
    end
  end
end
