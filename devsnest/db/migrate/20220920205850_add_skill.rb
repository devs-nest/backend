class AddSkill < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :name

      t.timestamps
    end

    create_table :job_skill_mappings do |t|
      t.references :job, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
