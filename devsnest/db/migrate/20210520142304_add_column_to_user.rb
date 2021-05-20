class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :batch, :string
    add_column :users, :grad_status, :string
    add_column :users, :grad_specialization, :string
    add_column :users, :grad_year, :integer  
  end
end
