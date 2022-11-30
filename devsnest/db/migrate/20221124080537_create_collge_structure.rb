class CreateCollgeStructure < ActiveRecord::Migration[6.0]
  def change
    create_table :college_structures do |t|
      t.string :name
      t.integer :course

      t.string :batch
      t.integer :year
      t.integer :branch
      t.integer :specialization
      t.string :section

      t.integer :college_id

      t.timestamps
    end
  end
end
