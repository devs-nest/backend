require "rails_helper"

RSpec.describe CoinLogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/coin_logs").to route_to("coin_logs#index")
    end

    it "routes to #show" do
      expect(:get => "/coin_logs/1").to route_to("coin_logs#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/coin_logs").to route_to("coin_logs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/coin_logs/1").to route_to("coin_logs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/coin_logs/1").to route_to("coin_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/coin_logs/1").to route_to("coin_logs#destroy", :id => "1")
    end
  end
end
