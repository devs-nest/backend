class UpdateReferredField < ActiveRecord::Migration[6.0]
  def change
    create_table :referrals do |t|
      t.integer :user_id, unique: true
      t.string :referral_code
      t.timestamps
    end

    remove_column :users, :referred_company
    add_column :users, :referral_code, :string
  end
end
