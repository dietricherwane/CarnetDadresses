class AddAssistantFirstnameAndAssistantLastnameToJobExperiences < ActiveRecord::Migration
  def change
    add_column :job_experiences, :assistant_firstname, :string
    add_column :job_experiences, :assistant_lastname, :string
    add_column :job_experiences, :assistant_phone_number, :string
    add_column :job_experiences, :assistant_email, :string
  end
end
