class ChangeTypeOfScore < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :score, :float
  end
end
