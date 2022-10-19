class CreateJobApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :job_applications do |t|
      t.integer :user_id
      t.integer :job_id
      t.integer :status # enum applied, interview, offer, rejected
      t.string :email
      t.string :phone_number
      t.string :note_for_the_recruiter, required: false

      t.timestamps
    end
  end
end
