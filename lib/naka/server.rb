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
      user = User.first
      if params["cheat"] == "true"
        strategy = Naka::Strategies::RepairWithCheating.new(user)
      else
        strategy = Naka::Strategies::Repair.new(user)
      end
      strategy.run
      :ok
    end

    get '/mission' do
      user = User.first
      Naka::Strategies::Mission.new(user, [2, 9, 11]).run
      :ok
    end

    get '/supply' do
      user = User.first
      fleets = user.fleets
      ship_ids = fleets.select{|x| x.mission.nil? }.map(&:ship_ids).flatten.compact
      Naka::Strategies::Supply.new(user, ship_ids).run
      :ok
    end

    get '/ships' do
      user = User.first
      ships = user.ships_master
      ships.map {|id, item|
        item.to_h
      }.to_json
    end

    def user
      user = User.first
    end

    def create_ship(a, b, c, d)
      ships = user.ships_master
      response = user.api.factory.ship.create(a, b, c, d)
      ship_id = response[:api_data][:api_ship_id]
      p ships.detect{|ship| ship.id == ship_id}
    end

    get '/create/cv' do
      create_ship(400, 30, 500, 700)
      :ok
    end
    get '/create/bb' do
      create_ship(400, 100, 600, 30)
      :ok
    end
    get '/create/r-dd' do
      create_ship(250, 30, 200, 30)
      :ok
    end
    get '/create/cheap' do
      create_ship(30, 30, 30, 30)
      :ok
    end

    def create_weapon(a, b, c, d)
      user = User.first
      response = user.api.factory.weapon.create(a, b, c, d)
      if response[:api_data][:api_create_flag] == 0
        p :fail
      else
        weapon_id = response[:api_data][:api_slotitem_id]
        p user.api.factory.weapon.find(weapon_id).api_name
      end
    end

    get '/weapon/saiun' do
      create_weapon(20, 20, 10, 110)
      :ok
    end
    get '/weapon/cheap' do
      create_weapon(10, 10, 10, 10)
      :ok
    end

    get '/quests' do
      user = User.first
      quests = user.quests
      quests.each do |quest|
        user.complete_quest(quest.id) if quest.completable?
      end
      user.quests.to_json
    end
  end
end
