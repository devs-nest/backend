class ChallegesDbChangesAndCreateCompanyTables < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :content_type, :integer
    add_column :challenges, :unique_id, :string
    add_column :challenges, :parent_id, :string
    change_column :users, :score, :integer, :default => 0

    create_table :companies do |t|
      t.string :name
  
      t.timestamps
    end

    create_table :company_challenge_mappings do |t|
      t.integer :challenge_id
      t.integer :company_id
      
      t.timestamps
    end
  end
end
