class AddTimestampsToFeSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :fe_submissions , null: Time.zone.now
  end
end
