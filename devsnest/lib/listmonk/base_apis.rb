module Listmonk
  class BaseApis
    def initialize(endpoint, username, password)
      @endpoint = endpoint
      @auth = { :username => username, :password => password }
    end
  end
end