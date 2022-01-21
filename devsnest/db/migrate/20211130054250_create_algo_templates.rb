class CreateAlgoTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :algo_templates do |t|
      t.integer :challenge_id
      t.integer :language_id
      t.text :head
      t.text :body
      t.text :tail
      t.index ["challenge_id", "language_id"], unique: true

      t.timestamps
    end
  end
end
