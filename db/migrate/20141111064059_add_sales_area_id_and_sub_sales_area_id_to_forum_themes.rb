class AddSalesAreaIdAndSubSalesAreaIdToForumThemes < ActiveRecord::Migration
  def change
    add_column :forum_themes, :job_category, :string
    add_column :forum_themes, :sub_sales_area_id, :integer
  end
end
