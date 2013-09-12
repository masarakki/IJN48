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

    get '/master/ships' do
      User.first.ships_master.to_json
    end

    get "/master/map" do
      User.first.api.master.map(params[:map].to_i, params[:area].to_i).to_json
    end

    # sample code to repair ship
    get '/repair' do
      user = User.first
      if params["cheat"] == "true"
        strategy = Naka::Strategies::RepairWithCheating.new(user)
      else
        strategy = Naka::Strategies::Repair.new(user)
      end
      ships = user.ships
      response = strategy.start
      response.select(&:used?).map do |dock|
        ship = ships.detect{|ship| ship.id == dock.ship_id}
        {ship: ship.master.name, repairs_in: dock.repairs_in} if ship
      end.to_json
    end

    get '/mission' do
      user = User.first
      Naka::Strategies::Mission.new(user, [3, 5, 6]).start
      user.fleets.map(&:mission).compact.to_json
    end

    get '/supply' do
      user = User.first
      fleets = user.fleets
      ship_ids = fleets.select{|x| x.mission.nil? }.map(&:ship_ids).flatten.compact
      Naka::Strategies::Supply.new(user, ship_ids).start
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
      Naka::Strategies::CreateShip.new(user, [a, b, c, d]).start
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
      Naka::Strategies::CreateWeapon.new(user, [a, b, c, d]).start
    end

    get '/weapon/aircraft' do
      create_weapon(20, 60, 10, 210)
    end

    get '/weapon/cheap' do
      create_weapon(10, 10, 10, 10)
    end

    get '/quests' do
      user = User.first
      quests = user.quests
      quests.each do |quest|
        user.complete_quest(quest.id) if quest.completable?
      end
      user.quests.to_json
    end

    get '/practice' do
      user = User.first
      practices = user.api.practice.all
      practice = practices.detect{|x| !x.finished?}
      Naka::Strategies::Practice.new(user, practice).start
      :ok
    end

    get '/battle/a-go' do
      user = User.first
      Naka::Strategies::Battle.new(user, 1, 1).start
      :ok
    end

    get '/battle/sw' do
      user = User.first
      Naka::Strategies::Battle.new(user, 2, 2).start
      :ok
    end

    get '/battle/3-2' do
      user = User.first
      Naka::Strategies::Battle.new(user, 3, 2, {:one => true}).start
      :ok
    end
  end
end
