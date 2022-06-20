class AddIndexToMemberCount < ActiveRecord::Migration[6.0]
  def change
    add_index :groups, :members_count
  end
end
