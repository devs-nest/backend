class ChangeUniquenessOfColumns < ActiveRecord::Migration[6.0]
  def change
    change_column :certifications, :cuid, :string, unique: true
    change_column :users, :username, :string, unique: true
  end
end
