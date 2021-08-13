class Createhackathon < ActiveRecord::Migration[6.0]
  def change
    create_table :hackathons do |t|
      t.string :title
      t.string :tagline
      t.string :reference
      t.string :description
      t.string :image
      t.json :leaderboard
      t.string :participation
      t.string :judgement
      t.string :milestones
      t.string :prizes
      t.date :starting_date
      t.date :ending_date
    end
  end
end
