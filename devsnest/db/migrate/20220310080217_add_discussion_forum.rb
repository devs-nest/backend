class AddDiscussionForum < ActiveRecord::Migration[6.0]
  def change
    create_table :discussions do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.integer :parent_id
      t.string :title
      t.text :body
      t.index %i[user_id]
      t.index %i[challenge_id parent_id]


      t.timestamps
    end

    create_table :upvotes do |t|
      t.integer :content_id
      t.string :content_type
      t.integer :user_id
      t.index %i[user_id content_id content_type], unique: true

      t.timestamps
    end
  end
end
