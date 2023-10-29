class CreateCollegeBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :college_branches do |t|
      t.references :college, null: false, foreign_key: true
      t.json :branches
      t.timestamps
    end
  end
end
