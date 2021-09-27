class Createcertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :certifications do |t|
      t.integer :user_id
      t.string :user_name
      t.string :hackathon_name
      t.string :rank
      t.string :team_name
      t.date :issuing_date
    end
  end
end
