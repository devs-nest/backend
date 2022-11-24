class CreateCollgeStructureMapping < ActiveRecord::Migration[6.0]
  def change
    create_table :collge_structure_mappings do |t|
      t.references :collge_structure, null: false, foreign_key: true
      t.references :college_profile, null: false, foreign_key: true
    end
  end
end
