class AddLangDescriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :languages, :language_description, :string
  end
end
