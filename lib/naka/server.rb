require 'sinatra/base'
require 'haml'

module Naka
  class Server < Sinatra::Base
    get '/' do
      haml :index
    end

    post '/' do
      require 'cgi'
      user = User.from_request(params[:owner_id], params[:url])
    end
  end
end
