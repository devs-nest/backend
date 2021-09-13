class CreateBot < ActiveRecord::Migration[6.0]
  def change
    create_table :bots do |t|
      t.string :bot_token
    end
  end
end
