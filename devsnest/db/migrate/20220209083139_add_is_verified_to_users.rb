class AddIsVerifiedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_verified, :boolean, default: false

    User.all.each { |user| user.update_column(:is_verified, true) }
  end
end
