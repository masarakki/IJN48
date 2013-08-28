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
      if params["cheat"] == "true"
        strategy = Naka::Strategies::RepairWithCheating.new(user)
      else
        strategy = Naka::Strategies::Repair.new(user)
      end
      strategy.run
      :ok
    end

    get '/mission' do
      user = User.restore(User.all.first)
      Naka::Strategies::Mission.new(user, [2, 9, 11]).run
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

    get '/create' do
      user = User.restore(User.all.first)
      ships = user.ships_master
      response = user.create_ship(300, 30, 600, 400)
      ship_id = response[:api_data][:api_ship_id]
      p ships.detect{|ship| ship.id == ship_id}
      :ok
    end

    get '/quests' do
      user = User.restore(User.all.first)
      quests = user.quests
      quests.each do |quest|
        user.complete_quest(quest.id) if quest.completable?
      end
      quests.to_json
    end
  end
end
