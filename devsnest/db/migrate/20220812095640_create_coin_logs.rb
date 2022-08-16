class CreateCoinLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :coin_logs do |t|
      t.string :title
      t.text :description
      t.string :pointable_type
      t.integer :pointable_id
      t.integer :coins, default: 0
    end
  end
end
