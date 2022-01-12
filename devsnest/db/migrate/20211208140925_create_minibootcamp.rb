class CreateMinibootcamp < ActiveRecord::Migration[6.0]
  def change
    create_table :minibootcamps do |t|
      t.integer :frontend_question_id
      t.string :unique_id, null: false, unique: true
      t.string :parent_id
      t.string :name
      t.integer :content_type
      t.text :markdown
      t.string :video_link
      t.string :image_url
      t.integer :current_lesson_number
      t.boolean :show_ide
      t.index %i[frontend_question_id]
      t.timestamps
    end
  end
end
