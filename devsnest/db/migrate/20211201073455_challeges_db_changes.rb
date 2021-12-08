class ChallegesDbChanges < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :company_tags, :text
    add_column :challenges, :content_type, :integer
    add_column :challenges, :unique_id, :string
    add_column :challenges, :parent_id, :string
  end
end
