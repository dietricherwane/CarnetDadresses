class AddUserIdToJobExperiences < ActiveRecord::Migration
  def change
    add_column :job_experiences, :user_id, :integer
  end
end
