class AddLogoInSkill < ActiveRecord::Migration[6.0]
  def change
    add_column :skills, :logo, :string
  end
end
