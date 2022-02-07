class CreateFrontendProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :frontend_projects do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.integer :template
      t.boolean :public, default: true
      t.index ["user_id", "name"], name: "index_projects_on_user_id_and_name", unique: true

      t.timestamps
    end
  end
end
