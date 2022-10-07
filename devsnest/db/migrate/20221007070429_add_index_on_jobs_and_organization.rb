class AddIndexOnJobsAndOrganization < ActiveRecord::Migration[6.0]
  def change
    add_index :job_skill_mappings, %i[job_id skill_id], unique: true
    add_index :job_applications, %i[user_id job_id], unique: true
    add_index :jobs, :slug, unique: true
    add_index :organizations, :slug, unique: true
  end
end
