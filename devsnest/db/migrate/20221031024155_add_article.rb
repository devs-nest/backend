class AddArticle < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :author
      t.text :content
      t.string :banner
      t.string :category

      t.timestamps
    end

    create_table :article_submissions do |t|
      t.references :article, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :submission_link
    end
  end
end
