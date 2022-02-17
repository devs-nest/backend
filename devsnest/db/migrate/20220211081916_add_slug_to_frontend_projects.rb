class AddSlugToFrontendProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :frontend_projects, :slug, :string 
  end
end
