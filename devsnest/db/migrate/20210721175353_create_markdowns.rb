class CreateMarkdowns < ActiveRecord::Migration[6.0]
  def change
    create_table :markdowns do |t|
      t.text :template
    end
  end
end
