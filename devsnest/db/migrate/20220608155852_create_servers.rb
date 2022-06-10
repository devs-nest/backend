class CreateServers < ActiveRecord::Migration[6.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :guild_id
      t.string :link
      t.timestamps
    end
  end
end
