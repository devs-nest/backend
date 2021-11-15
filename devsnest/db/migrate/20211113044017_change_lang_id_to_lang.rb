class ChangeLangIdToLang < ActiveRecord::Migration[6.0]
  def up
    rename_column :algo_submissions, :language_id, :language
    change_column :algo_submissions, :language, :string
  end

  def down
    rename_column :algo_submissions, :language, :language_id
    change_column :algo_submissions, :language_id, :integer
  end
end
