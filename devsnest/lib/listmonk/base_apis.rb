module Listmonk
  class BaseApis
    def initialize(endpoint, username, password)
      @endpoint = endpoint
      @auth = { :username => username, :password => password }
      @headers = { 'Content-Type': 'application/json' }
    end


    def get_subscribers(page = 0)
      response = HTTParty.get(@endpoint + '/api/subscribers')
    end

    def get_templates
      response = JSON.parse(HTTParty.get(@endpoint + '/api/templates', basic_auth: @auth))
    end

    def add_subscriber(user, list)
      payload = {
        "email": user.email,
        "name": user.name,
        "status": "enabled",
        "lists": list,
        "attribs": user.attributes
      }

      response = JSON.parse(HTTParty.post(@endpoint + '/api/subscribers', body: payload, basic_auth: @auth))
    end

    def tx(user, template_id, **data)
      payload = {
        'subscriber_id' => 3,
        'subscriber_email' => user.email,
        'template_id' => template_id,
        'status' => "enabled",
        'data' => data,
      }
      response = JSON.parse(HTTParty.post(@endpoint + '/api/tx', body: payload.to_json, headers: @headers, basic_auth: @auth))
    end
  end
end