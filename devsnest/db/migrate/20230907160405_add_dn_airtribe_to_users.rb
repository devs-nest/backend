class AddDnAirtribeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :dn_airtribe_student, :boolean, default: false
  end
end
