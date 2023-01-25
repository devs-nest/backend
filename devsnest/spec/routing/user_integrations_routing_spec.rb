require "rails_helper"

RSpec.describe UserIntegrationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/user_integrations").to route_to("user_integrations#index")
    end

    it "routes to #show" do
      expect(:get => "/user_integrations/1").to route_to("user_integrations#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/user_integrations").to route_to("user_integrations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_integrations/1").to route_to("user_integrations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_integrations/1").to route_to("user_integrations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_integrations/1").to route_to("user_integrations#destroy", :id => "1")
    end
  end
end
