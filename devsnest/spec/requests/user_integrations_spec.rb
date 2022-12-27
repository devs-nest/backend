require 'rails_helper'

RSpec.describe "UserIntegrations", type: :request do
  describe "GET /user_integrations" do
    it "works! (now write some real specs)" do
      get user_integrations_path
      expect(response).to have_http_status(200)
    end
  end
end
