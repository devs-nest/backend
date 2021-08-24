class Createhackathon < ActiveRecord::Migration[6.0]
  def change
    create_table :hackathons do |t|
      t.string :title
      t.string :tagline
      t.string :reference
      t.text :description
      t.text :image
      t.json :leaderboard
      t.text :participation
      t.text :judgement
      t.text :milestones
      t.text :prizes
      t.integer :teams_participated
      t.date :starting_date
      t.date :ending_date
    end
  end
end
