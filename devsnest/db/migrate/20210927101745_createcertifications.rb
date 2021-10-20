class Createcertifications < ActiveRecord::Migration[6.0]
  def change
    create_table :certifications do |t|
      t.integer :user_id
      t.string :certificate_type
      t.string :cuid, default: SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")
      t.string :title, default: ''
      t.index ["user_id", "certificate_type"], name: "index_certificates_on_user_id_and_certificate_type", unique: true
      t.timestamps
    end
  end
end
