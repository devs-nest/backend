class CreateLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages do |t|
      t.integer :judge_zero_id 
      t.string :name
      t.string :memory_limit
      t.string :time_limit
      t.string :type_array, default: ""
      t.string :type_matrix, default: ""
      t.string :type_string, default: ""
      t.string :type_primitive, default: ""

      t.timestamps
    end
  end
end
