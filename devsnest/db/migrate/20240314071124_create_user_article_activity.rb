class CreateUserArticleActivity < ActiveRecord::Migration[7.0]
  def change
    create_table :user_article_activities do |t|
      t.integer :user_id, null: false
      t.integer :article_id, null: false
      t.boolean :seen, default: false

      t.index %i[user_id article_id], name: "index_user_article_activities"
      t.timestamps
    end
  end
end
