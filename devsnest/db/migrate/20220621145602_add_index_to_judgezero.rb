class AddIndexToJudgezero < ActiveRecord::Migration[6.0]
  def change
    add_index :judgeztokens, [:token, :submission_id]
  end
end
