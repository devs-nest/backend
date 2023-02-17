class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.integer :challenge_id
      t.string :challenge_type
      t.string :banner

      t.timestamps
    end
  end
end
