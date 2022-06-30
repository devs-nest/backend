class ChangeTypeOfBacklogScrum < ActiveRecord::Migration[6.0]
  def change
    change_column :scrums, :backlog_reasons, :text
  end
end
