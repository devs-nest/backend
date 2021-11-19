class AddTesterCodeToChallenges < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :tester_code, :text
    add_column :challenges, :created_by, :integer
    add_column :challenges, :slug, :string, unique: true
    change_column :challenges, :name, :string, unique: true
  end
end
