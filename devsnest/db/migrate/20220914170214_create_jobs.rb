class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.integer :organization_id
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :salary
      t.integer :job_type # enum remote or onsite
      t.integer :job_category # enum full-time, part-time, contract, internship
      t.string :location
      t.string :experience
      t.boolean :archived, default: false
      t.json :additional

      t.timestamps
    end
  end
end
