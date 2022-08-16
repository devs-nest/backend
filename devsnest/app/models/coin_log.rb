class CoinLog < ApplicationRecord
  belongs_to :pointable, polymorphic: true
end
