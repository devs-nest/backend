module Listmonk
  META_LIST = {
    active_members: {
      conditions: {
        web_active: ' == true',
        discord_active: ' == true'
      },
      preserve_list: false
    },
    # sample 
    # active_dsa:{
    #   conditions:{
    #     user_challenge_score: {
    #       count: ' > 50',
    #       fe_submissions: {
    #         count: ' > 10'
    #       }
    #     }
    #   }
    # }
  }

  class BaseApis
    def initialize(endpoint, username, password)
      @endpoint = endpoint
      @auth = { :username => username, :password => password }
      @headers = { 'Content-Type': 'application/json' }
    end

    
    def get_templates
      response = JSON.parse(HTTParty.get(@endpoint + '/api/templates', basic_auth: @auth).response.body)
    end
    
    def tx(user, template_id, **data)
      payload = {
        'subscriber_email' => user.email,
        'template_id' => template_id,
        'status' => "enabled",
        'data' => data,
      }
      response = JSON.parse(HTTParty.post(@endpoint + '/api/tx', body: payload.to_json, headers: @headers, basic_auth: @auth).response.body)
    end
    
    def list_control(changed_attributes, user)
      @list_cont = []
      META_LIST.each do |list, val|
        q = query_string(val[:conditions])
        list_id = JSON.parse(HTTParty.get(@endpoint + '/api/lists', headers: @headers, basic_auth: @auth).response.body)["data"]["results"].pluck('id', 'name').select { |z| z[1] == list.to_s }.flatten[0]
        # current_lists = current_sub.present? current_sub['lists'].pluck('id') : nil
        subscriber_id = user.listmonk_subscriber_id
        current_sub = get_subscriber(subscriber_id)
        
        return if current_sub["data"]["lists"].pluck("name").include?(list.to_s)
        
        list_id = get_list_id(list.to_s)
        
        updated_lists = current_sub["data"]["lists"].pluck("id") << list_id
        payload = {
          email: user.email,
          name: user.name,
          status: 'enabled',
          lists: updated_lists,
          preconfirm_subscriptions: true
        }
        
        if eval(q.join(" && "))
          if current_sub.present?
            response = JSON.parse(HTTParty.put(@endpoint + '/api/subscribers/' + subscriber_id, body: payload.to_json, headers: @headers, basic_auth: @auth).response.body)
          else
            response = JSON.parse(HTTParty.post(@endpoint + '/api/subscribers', body: payload.to_json, headers: @headers, basic_auth: @auth).response.body)
          end
          # TODO
          # elsif 
          # response = JSON.parse(HTTParty.delete(@endpoint + '/api/subscribers', body: payload.to_json, headers: @headers, basic_auth: @auth).response.body)
        end
      end
    end
    
    def get_subscribers_details(**field)
      key, val = *field.flatten
      JSON.parse(HTTParty.get(@endpoint + '/api/subscribers?per_page=all', headers: @headers, basic_auth: @auth).response.body)["data"]["results"].select { |r| r[key.to_s] == val }
    end

    def get_subscriber(page = 0, id)
      response = JSON.parse(HTTParty.get(@endpoint + '/api/subscribers/' + id, basic_auth: @auth).response.body)
    end
    
    def add_subscriber(user, lists)
      payload = {
        email: user.email,
        name: user.name,
        status: 'enabled',
        lists: lists,
        preconfirm_subscriptions: true
      }

      response = HTTParty.post(@endpoint + '/api/subscribers', body: payload.to_json, headers: @headers, basic_auth: @auth)
    end
    private

    def get_list_id(name = "Default list")
      JSON.parse(HTTParty.get(@endpoint + '/api/lists', headers: @headers, basic_auth: @auth).response.body)["data"]["results"].select { |r| r["name"] == name }
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