class AddUniquenessToNameInCompany < ActiveRecord::Migration[6.0]
  def change
    add_index :companies, :name, unique: true
  end
end
