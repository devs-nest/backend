class AddSlugToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :slug, :string
    add_index :articles, :slug, unique: true
  end
end
