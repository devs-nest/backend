# frozen_string_literal: true

module Listmonk
  META_LIST = {
    active_members: {
      conditions: {
        web_active: ' == true',
        discord_active: ' == true'
      },
      preserve_list: false,
      run_for_test_env: true
    }
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
  }.freeze

  class BaseApis
    def initialize(endpoint, username, password)
      @endpoint = endpoint
      @auth = { username: username, password: password }
      @headers = { 'Content-Type': 'application/json' }
    end

    def get_templates
      response = JSON.parse(HTTParty.get("#{@endpoint}/api/templates", basic_auth: @auth).response.body)
    end

    def tx(user, template_id, **data)
      payload = {
        'subscriber_email' => user.email,
        'template_id' => template_id,
        'status' => 'enabled',
        'data' => data
      }
      response = JSON.parse(HTTParty.post("#{@endpoint}/api/tx", body: payload.to_json, headers: @headers, basic_auth: @auth).response.body)
    end

    def list_control(_changed_attributes, user)
      @list_cont = []
      META_LIST.each do |list, val|
        next if Rails.env.test? && !val[:run_for_test_env]
        
        q = query_string(val[:conditions])
        # list = "#{Rails.env}_#{list}"
        list = "#{list}"
        list_id = get_list_id(list.to_s)
        
        return if list_id.nil? # list not found
        
        subscriber_id = user.listmonk_subscriber_id
        current_sub = get_subscriber(subscriber_id)
        current_sub_lists = current_sub['data']['lists']
        current_list = current_sub_lists.select { |l| l['name'] == list.to_s }
        
        return if current_sub_lists.select { |l| l['name'] == list.to_s }.first&.dig('subscription_status') == 'unsubscribed'
        
        add_subscriber(user, []) unless current_sub.present? # create sub if not present

        if eval(q.join(' && '))
          payload = update_list_payload(user, current_sub['data']['lists'].pluck('id'), list_id)
          response = JSON.parse(HTTParty.put("#{@endpoint}/api/subscribers/#{subscriber_id}", body: payload.to_json, headers: @headers, basic_auth: @auth).response.body)
        elsif !val[:preserve_list] # if conditions are not met
          payload = update_list_payload(user, current_sub['data']['lists'].pluck('id'), list_id, 'remove')
          response = JSON.parse(HTTParty.put("#{@endpoint}/api/subscribers/#{subscriber_id}", body: payload.to_json, headers: @headers, basic_auth: @auth).response.body)
        end
      end
    end

    def get_subscribers_details(**field)
      key, val = *field.flatten
      JSON.parse(HTTParty.get("#{@endpoint}/api/subscribers?per_page=all", headers: @headers, basic_auth: @auth).response.body)['data']['results'].select { |r| r[key.to_s] == val }
    end

    def get_subscriber(_page = 0, id)
      response = JSON.parse(HTTParty.get("#{@endpoint}/api/subscribers/#{id}", basic_auth: @auth).response.body)
    end

    def add_subscriber(user, lists)
      payload = {
        email: user.email,
        name: user.name,
        status: 'enabled',
        lists: lists,
        preconfirm_subscriptions: true
      }

      response = HTTParty.post("#{@endpoint}/api/subscribers", body: payload.to_json, headers: @headers, basic_auth: @auth)
    end

    private

    def update_list_payload(user, list, current_list, method = 'add')
      if method == 'remove'
        list.delete(current_list)
      else
        list = list << current_list
      end

      payload = {
        email: user.email,
        name: user.name,
        status: 'enabled',
        lists: list,
        preconfirm_subscriptions: true
      }
    end

    def get_list_id(name = 'Default list')
      JSON.parse(HTTParty.get("#{@endpoint}/api/lists", headers: @headers, basic_auth: @auth).response.body)['data']['results'].select { |r| r['name'] == name }.first&.dig("id")
    end

    def query_string(conditions, qs = 'user', querries = [])
      # p conditions, conditions.is_a?(Hash)
      unless conditions.is_a?(Hash)
        qs += conditions
        querries << qs
        return querries
      end

      conditions.each do |method, matcher|
        query_string(matcher, qs + ".#{method}", querries)
      end
      querries
    end
  end
end
