class CreateAlgoChallenges < ActiveRecord::Migration[6.0]
  def change
    create_table :challenges do |t|
      t.integer :topic
      t.integer :difficulty
      t.string :name
      t.text :question_body

      t.timestamps
    end
  end
end
