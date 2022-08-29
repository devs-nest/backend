class AddCurrentModuleToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :current_module, :string
  end
end
