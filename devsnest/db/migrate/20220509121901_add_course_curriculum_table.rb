class AddCourseCurriculumTable < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.boolean :archived, default: true
      t.index :name

      t.timestamps
    end

    create_table :course_curriculums do |t|
      t.integer :course_id
      t.integer :course_type
      t.string :topic
      t.integer :day
      t.text :video_link
      t.text :resources
      t.boolean :locked, default: true
      t.index %i[course_id course_type]
      t.index %i[course_id day]


      t.timestamps
    end

    create_table :assignment_questions do |t|
      t.integer :course_curriculum_id
      t.integer :question_id
      t.string  :question_type
    end

    add_column :challenges, :course_curriculum_id, :integer
  end
end
