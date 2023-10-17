class AddCollegeIndex < ActiveRecord::Migration[7.0]
  def change
    # execute "ALTER TABLE `colleges` DROP PRIMARY KEY"
    add_column :colleges, :slug, :string
    College.all.each do |clg|
      clg.save
    end
    add_index :colleges, :slug, unique: true
  end
end
