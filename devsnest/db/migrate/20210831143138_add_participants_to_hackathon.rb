class AddParticipantsToHackathon < ActiveRecord::Migration[6.0]
  def change
    add_column :hackathons, :participants, :json
  end
end
