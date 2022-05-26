class AddColumnTypeLinkedListToLanguages < ActiveRecord::Migration[6.0]
  def change
    add_column :languages, :type_linked_list, :string
  end
end
