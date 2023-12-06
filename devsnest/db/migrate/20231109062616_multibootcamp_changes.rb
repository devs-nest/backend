class MultibootcampChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :course_module_accesses do |t|
      t.references :accessor, polymorphic: true, null: false, index: true
      t.integer :status, default: 0

      t.timestamps
    end
    create_table :product_prices do |t|
      t.integer :price
      t.string :product_type, null: false
      t.string :product_name
      t.text :product_id
      t.boolean :active, default: true

      t.timestamps
    end
    create_table :product_discounts do |t|
      t.integer :product_id
      t.decimal :discount, precision: 10, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end
    create_table :course_modules do |t|
      t.integer :module_type
      t.integer :questions_table
      t.integer :best_submissions_table
      t.integer :submissions_table
      t.boolean :is_paid, default: false
      t.integer :timeline_status, default: 0
      t.integer :visibility, default: 0
      
      t.timestamps
    end

    add_column :orders, :product_price_id, :integer
    add_column :course_curriculums, :course_module_id, :integer
    add_reference :course_module_accesses, :course_module, foreign_key: true, null: false, index: true
  end
end
