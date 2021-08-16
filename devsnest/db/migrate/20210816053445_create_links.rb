class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :slug
      t.text :address
      t.index %i[slug], unique: true
    end
  end
end

