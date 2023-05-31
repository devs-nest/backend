class AddOtpLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :otp_logs do |t|
      t.string :phone_number
      t.integer :timeout
      t.integer :request_count

      t.index :phone_number
      t.timestamps
    end
  end
end
