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
      ships = user.ships
      docks = user.docks
      blank_docks = docks.select(&:blank?)
      return :ok unless blank_docks

      repairing_ship_ids = docks.select(&:used?).map(&:ship_id)
      damaged_ships = ships.select{|ship| ship.damaged? && !repairing_ship_ids.include?(ship.id)}.
        sort_by{|x| x.hp.max - x.hp.now}.reverse
      blank_docks.zip(damaged_ships).each do |dock, ship|
        user.repair(ship, dock) unless dock.nil? || ship.nil?
      end
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

    get '/ships' do
      user = User.restore(User.all.first)
      ships = user.ships_master
      ships.map {|id, item|
        item.to_h
      }.to_json
    end
  end
end
