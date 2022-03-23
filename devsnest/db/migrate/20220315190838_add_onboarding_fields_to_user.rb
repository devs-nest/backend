class AddOnboardingFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :working_status, :string
    add_column :users, :is_fullstack_course_22_form_filled, :boolean, default: false
    add_column :users, :phone_number, :string
    add_column :users, :working_role, :string
    add_column :users, :company_name, :string
    add_column :users, :college_name, :string
    add_column :users, :college_year, :integer
  end
end
