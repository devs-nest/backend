class BootcampAccess < ActiveRecord::Migration[7.0]
  def change
    create_table :bootcamp_accesses do |t|
      t.references :accessible, polymorphic: true, null: false, index: true
      t.integer :status
      t.references :course, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_column :courses, :visibility, :integer, default: 0, null: false
  end
end
