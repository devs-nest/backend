class AddSlugToChallenges < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :slug, :string
    add_index :challenges, :slug, unique: true
  end
end
