class AddUserIntegrationCache < ActiveRecord::Migration[6.0]
  def change
    create_table :user_integration_caches do |t|

      t.text :leetcode_cache, limit: 700000
      t.text :gfg_cache, limit: 700000
      t.text :hackerrank_cache, limit: 700000
      t.text :github_cache, limit: 700000
      t.integer :user_integration_id
      t.timestamps
    end
  end
end
