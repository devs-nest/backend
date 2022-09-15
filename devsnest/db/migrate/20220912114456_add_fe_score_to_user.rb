class AddFeScoreToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :fe_score, :integer, default: 0
  end
end
