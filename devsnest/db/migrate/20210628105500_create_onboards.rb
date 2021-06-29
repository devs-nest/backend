class CreateOnboards < ActiveRecord::Migration[6.0]
  def change
    create_table :onboards do |t|

      t.timestamps
    end
  end
end
