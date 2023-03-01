class AddTypeToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :resource_type, :integer, null: false
    add_index :articles, :resource_type
  end
end
