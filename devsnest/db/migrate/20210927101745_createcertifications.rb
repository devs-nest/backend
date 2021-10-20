class Createcertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :certifications do |t|
      t.integer :user_id
      t.string :username
      t.string :name
      t.string :hackathon_name
      t.string :rank
      t.string :team_name
      t.string :certificate_type
      t.string :title, default: ''
      t.string :cuid, default: SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")
      t.text :description
    end
  end
end
