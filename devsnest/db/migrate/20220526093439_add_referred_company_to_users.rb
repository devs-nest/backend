class AddReferredCompanyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :referred_company, :string
  end
end
