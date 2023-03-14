class CreateUserIntegrations < ActiveRecord::Migration[6.0]
  def change
    create_table :user_integrations do |t|

      t.string :leetcode_user_name
      t.string :gfg_user_name
      t.string :hackerrank_user_name
      t.integer :user_id
      t.timestamps
    end
  end
end
