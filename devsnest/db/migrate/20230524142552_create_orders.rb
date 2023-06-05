class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.string :razorpay_signature
      t.string :razorpay_payment_link_id
      t.string :payment_link
      t.float :amount
      t.string :description
      t.string :status
      t.integer :user_id
      t.string :currency

      t.timestamps
    end
  end
end
