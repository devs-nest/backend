class CreateJudgeztokens < ActiveRecord::Migration[6.0]
  def change
    create_table :judgeztokens do |t|
      t.integer :submission_id
      t.string :token
      t.timestamps
    end
  end
end
