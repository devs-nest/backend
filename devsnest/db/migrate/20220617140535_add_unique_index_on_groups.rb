class AddUniqueIndexOnGroups < ActiveRecord::Migration[6.0]
  def change
    add_index :groups, :name, unique: true
    add_index :groups, :slug, unique: true
  end
end
