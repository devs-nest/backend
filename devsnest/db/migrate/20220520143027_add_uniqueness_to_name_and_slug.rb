class AddUniquenessToNameAndSlug < ActiveRecord::Migration[6.0]
  def change
    change_column :groups, :name, :string, unique: true
    change_column :groups, :slug, :string, unique: true
  end
end
