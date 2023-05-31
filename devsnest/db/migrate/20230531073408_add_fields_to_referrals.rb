class AddFieldsToReferrals < ActiveRecord::Migration[7.0]
  def change
    add_column :referrals, :referred_by, :integer
    add_column :referrals, :referral_type, :integer, default: 0
  end
end
