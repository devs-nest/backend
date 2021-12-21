class CreateMinibootcamp < ActiveRecord::Migration[6.0]
  def change
    create_table :minibootcamps do |t|
      t.string :unique_id, null: false, unique: true
      t.string :parent_id
      t.string :name
      t.integer :content_type
      t.text :markdown
      t.integer :template
      t.string :active_path
      t.text :open_paths
      t.json :files
      t.text :protected_paths
      t.string :video_link
      t.string :image_url
      t.boolean :show_explorer
      t.boolean :show_ide
      t.timestamps
    end
  end
end
