class AddUserSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :user_skills do |t|

      t.integer :user_id
      t.integer :skill_id
      t.integer :level
      t.timestamps
    end

    change_column :skills, :logo, :text, unique: true, :limit => 700000
  end
end
