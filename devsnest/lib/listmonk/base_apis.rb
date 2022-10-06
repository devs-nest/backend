module Listmonk
  META_LIST = {
    active_member: {
      conditions: {
        web_active: ' == true',
        discord_active: ' == true'
      },
      preserve_list: false
    },
    # sample 
    active_dsa:{
      conditions:{
        user_challenge_score: {
          count: ' > 50',
          fe_submissions: {
            count: ' > 10'
          }
        }
      }
    }
  }

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
      response = JSON.parse(HTTParty.post(@endpoint + '/api/subscribers', body: payload, headers: @headers, basic_auth: @auth))
    end

    def tx(user, template_id, **data)
      payload = {
        'subscriber_email' => user.email,
        'template_id' => template_id,
        'status' => "enabled",
        'data' => data,
      }
      response = JSON.parse(HTTParty.post(@endpoint + '/api/tx', body: payload.to_json, headers: @headers, basic_auth: @auth))
    end

    def list_control(changed_attributes, user)
      @list_cont = []
      byebug
      # TODO
    end

    def query_string(conditions, qs = 'user', querries = [])
      # p conditions, conditions.is_a?(Hash)
      unless conditions.is_a?(Hash)
        qs = qs + conditions
        querries << qs
        return querries
      end

      conditions.each do |method, matcher|
        query_string(matcher, qs + ".#{method}", querries)
      end
      return querries
    end
  end
end