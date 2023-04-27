class AddFormColumnsToEduEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :edu_events, :form_columns, :json
  end
end
