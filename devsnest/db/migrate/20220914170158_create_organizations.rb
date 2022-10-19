class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :website
      t.string :logo_banner
      t.string :logo
      t.string :heading
      t.json :additional

      t.timestamps
    end
  end
end
