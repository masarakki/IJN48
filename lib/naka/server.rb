require 'sinatra/base'
require 'haml'
require 'json'

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
      strategy = Naka::Strategies::Repair.new(user)
      strategy.run
      :ok
    end

    get '/mission' do
      mission_ids = [2, 9, 11]
      user = User.restore(User.all.first)
      fleets = user.fleets
      enable_mission_ids = mission_ids - fleets.map{|fleet| fleet.mission.id if fleet.mission }
      fleets.select(&:missionable?).zip(enable_mission_ids).each do |fleet, mission_id|
        user.start_mission(fleet.id, mission_id) if fleet && mission_id
      end
      :ok
    end

    get '/supply' do
      user = User.restore(User.all.first)
      fleets = user.fleets
      ship_ids = fleets.select{|x| x.mission.nil? }.map(&:ship_ids).flatten.compact
      Naka::Strategies::Supply.new(user, ship_ids).run
      :ok
    end

    get '/ships' do
      user = User.restore(User.all.first)
      ships = user.ships_master
      ships.map {|id, item|
        item.to_h
      }.to_json
    end
  end
end
