class AddTreeVar < ActiveRecord::Migration[6.0]
  def change
    add_column :languages, :type_binary_tree, :string
  end
end
