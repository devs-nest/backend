class AddColsToOnboards < ActiveRecord::Migration[6.0]
  def change
    add_column :onboards, :discord_username, :string, null: false, default: ''
    add_column :onboards, :discord_id, :string, null: false, default: ''
    add_column :onboards, :name, :string, null: false, default: ''
    add_column :onboards, :college, :string, null: false, default: ''
    add_column :onboards, :college_year, :string, null: false, default: ''
    add_column :onboards, :school, :string, default: ''
    add_column :onboards, :work_exp, :string, null: false, default: ''
    add_column :onboards, :known_from, :string, null: false, default: ''
    add_column :onboards, :dsa_skill, :integer, null: false, default: 0
    add_column :onboards, :webd_skill, :integer, null: false, default: 0
  end
end
