require 'listmonk/base_apis'
module Listmonk
  class SubscribeApis < Listmonk::BaseApis
    def initialize(list = [], user)
      @user = user
      @list = list
    end

    def payload
      {
        "email": @user.email,
        "name": @user.name,
        "status": "enabled",
        "lists": @list,
        "attribs": @user.attributes
      }
    end

    def add_subscriber
      resp = HTTParty.post(@endpoint + '/api/subscribers', body: payload, basic_auth: @auth)
      byebug
    end
  end
end