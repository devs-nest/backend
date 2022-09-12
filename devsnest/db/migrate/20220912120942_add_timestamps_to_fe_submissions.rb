class AddTimestampsToFeSubmissions < ActiveRecord::Migration[6.0]
  change_table :fe_submissions do |t|
    t.timestamps default: Time.current
    t.change_default :created_at, from: Time.current, to: nil
    t.change_default :updated_at, from: Time.current, to: nil
  end
end
