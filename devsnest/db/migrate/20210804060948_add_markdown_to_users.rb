class AddMarkdownToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :markdown, :text
  end
end
