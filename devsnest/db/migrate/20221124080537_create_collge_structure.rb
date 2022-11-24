class CreateCollgeStructure < ActiveRecord::Migration[6.0]
  def change
    create_table :collge_structures do |t|
      t.integer :college_type
      t.integer :value
      t.integer :college_id

      t.timestamps
    end
  end
end
