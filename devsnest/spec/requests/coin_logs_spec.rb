require 'rails_helper'

RSpec.describe "CoinLogs", type: :request do
  describe "GET /coin_logs" do
    it "works! (now write some real specs)" do
      get coin_logs_path
      expect(response).to have_http_status(200)
    end
  end
end
