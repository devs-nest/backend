class Createcertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :certifications do |t|
      t.integer :user_id
      t.string :user_name
      t.string :name
      t.string :hackathon_name
      t.string :rank
      t.string :team_name
      t.string :title
      t.string :uuid, default: SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")
      t.text :description
      t.date :issuing_date
    end
  end
end
