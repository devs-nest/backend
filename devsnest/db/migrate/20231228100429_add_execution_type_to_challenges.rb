class AddExecutionTypeToChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :execution_type, :integer, default: 0
  end
end
