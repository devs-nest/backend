class AddCollegeIndex < ActiveRecord::Migration[7.0]
  def change
    add_column :colleges, :slug, :string
  end
end
