require 'sinatra/base'
require 'haml'

module Naka
  class Server < Sinatra::Base
    get '/' do
      haml :index
    end

    post '/' do
      User.from_request(params[:owner_id], params[:url]).store
      :ok
    end

    # sample code to repair ship
    get '/repair' do
      user = User.restore(User.all.first)
      ships = user.ships[:ships]
      damaged_ships = ships.select(&:damaged?).sort_by{|x| x.hp.max - x.hp.now}.reverse
      blank_docks = user.docks.select(&:blank?)
      blank_docks.zip(damaged_ships).each do |dock, ship|
        user.repair(ship, dock)
      end
      :ok
    end
  end
end
