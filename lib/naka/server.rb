require 'sinatra/base'
require 'haml'

module Naka
  class Server < Sinatra::Base
    get '/' do
      haml :index
    end

    post '/' do
      require 'cgi'

      user_id = params[:owner_id]
      uri = URI.parse(params[:url])
      host = uri.host
      query = CGI.parse(uri.query)
      api_token = query["api_token"].first
      api_starttime = query["api_starttime"].first

      # user_id, host, api_token, api_starttime
    end
  end
end
