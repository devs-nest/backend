class AddPercentageCompleteToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :percent_complete, :decimal
  end
end
