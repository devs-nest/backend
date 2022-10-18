#initialize only if env is present

if ENV.select {|k, v| k.starts_with?('LISTMONK')}.present?
  Dir["lib/listmonk/*"].each { |file| require file.split('/', 2)[-1].split('.')[0] }# include Listmonk
  $listmonk = Listmonk::BaseApis.new(endpoint = ENV['LISTMONK_HOST'], username = ENV['LISTMONK_USERNAME'], password = ENV['LISTMONK_PASSWORD'])
end
