class CreateLanguageChallengeMapping < ActiveRecord::Migration[7.0]
  def change
    create_table :language_challenge_mappings do |t|
      t.references :challenge, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end
  end
end
