class AddAdressBookIdToPreviousJobExperiences < ActiveRecord::Migration
  def change
    add_column :previous_job_experiences, :adress_book_id, :integer
  end
end
