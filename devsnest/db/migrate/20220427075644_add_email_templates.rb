class AddEmailTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :email_templates do |t|
      t.string :template_id
      t.string :name
      t.index %i[template_id name]
    end
  end
end
