class AddScoreToContent < ActiveRecord::Migration[6.0]
  def change
  	add_column :contents, :score, :integer
  end
end
