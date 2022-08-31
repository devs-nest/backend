class CreateCoinLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :coin_logs do |t|
      t.string :pointable_type
      t.integer :pointable_id
      t.integer :coins, default: 0
      t.integer :user_id
      t.timestamps
    end

    create_table :rewards do |t|
      t.string :title
      t.text :description
      t.timestamps
    end
  end
end
