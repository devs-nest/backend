class AddImageUrlToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :image_url, :string
  end
end
