class AddIndexOnChallengeIdAndCompanyId < ActiveRecord::Migration[6.0]
  def change
    add_index :company_challenge_mappings, [:challenge_id, :company_id], unique: true 
  end
end
