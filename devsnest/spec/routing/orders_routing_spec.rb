require "rails_helper"

RSpec.describe OrdersController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/orders").to route_to("orders#create")
    end
  end
end
