class AddPublishedToJobExperiences < ActiveRecord::Migration
  def change
    add_column :job_experiences, :published, :boolean
  end
end
