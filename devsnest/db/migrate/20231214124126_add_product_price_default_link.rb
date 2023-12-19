class AddProductPriceDefaultLink < ActiveRecord::Migration[7.0]
  def change
    add_column :product_prices, :redirect_url, :string, default: ''
  end
end
