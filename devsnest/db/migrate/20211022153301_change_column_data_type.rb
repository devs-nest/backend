class ChangeColumnDataType < ActiveRecord::Migration[6.0]
  def change
    def up
      change_column :challenges, :topic, :integer
    end

    def down
      change_column :challenges, :topic, :string
    end
  end
end
