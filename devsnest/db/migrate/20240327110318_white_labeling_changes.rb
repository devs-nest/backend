class WhiteLabelingChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants do |t|
      t.string :subdomain, null: false
      t.string :name, null: false

      t.timestamps null: false
    end

    add_column :groups, :tenant_id, :integer, null: false
    add_index :groups, :tenant_id

    add_column :courses, :tenant_id, :integer, null: false
    add_index :courses, :tenant_id

    add_column :course_modules, :tenant_id, :integer, null: false
    add_index :course_modules, :tenant_id
  end
end
