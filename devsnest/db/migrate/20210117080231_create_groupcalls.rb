class CreateGroupcalls < ActiveRecord::Migration[6.0]
  def change
    create_table :groupcalls do |t|
      t.integer :user_id
      t.integer :choice
      
      t.timestamps
    end
  end
end
