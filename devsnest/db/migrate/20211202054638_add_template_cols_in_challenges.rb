class AddTemplateColsInChallenges < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :input_format, :json
    add_column :challenges, :output_format, :json
  end
end
