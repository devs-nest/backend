class MakeDiscussionTablePolymorphic < ActiveRecord::Migration[6.0]
  def change
    rename_column :discussions, :challenge_id, :question_id
    add_column :discussions, :question_type, :string
  end
end
