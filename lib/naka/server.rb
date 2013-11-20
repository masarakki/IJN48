require 'sinatra/base'
require 'sinatra/namespace'
require 'haml'
require 'json'

module Naka
  class Server < Sinatra::Base
    register Sinatra::Namespace

    get '/' do
      @areas = user.api.master.area
      @mapinfos = user.api.master.mapinfo.select(&:enabled?).group_by(&:area_id)
      haml :index
    end

    post '/' do
      User.from_request(params[:owner_id], params[:url]).store
      :ok
    end

    get '/game' do
      redirect "http://#{user.api_host}/kcs/mainD2.swf?api_token=#{user.api_token}&api_starttime=#{user.api_at}"
    end

    get '/master/ships' do
      user.ships_master.to_json
    end

    get "/master/map" do
      user.api.master.map(params[:map].to_i, params[:area].to_i).to_json
    end

    namespace '/user' do
      get '/ships' do
        user.ships.to_json
      end

      get '/ships/destroy' do
        Naka::Strategies::DestroyShips.new(user).start.to_json
      end

      get '/fleets' do
        ships = user.ships
        fleets = user.fleets
        fleets.map do |fleet|
          fleet.ships = fleet.ship_ids.compact.map do |ship_id|
            ships.detect{|ship| ship.id == ship_id}
          end
        end
        fleets.to_json
      end

      get '/status' do
        user.api.status.materials.to_json
      end
    end

    # sample code to repair ship
    get '/repair' do
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
      Naka::Strategies::Mission.new(user).start
      user.fleets.map(&:mission).compact.to_json
    end

    get '/supply' do
      fleets = user.fleets
      ship_ids = fleets.select{|x| x.mission.nil? }.map(&:ship_ids).flatten.compact
      Naka::Strategies::Supply.new(user, ship_ids).start
      :ok
    end

    get '/ships' do
      ships = user.ships_master
      ships.map {|id, item|
        item.to_h
      }.to_json
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
      Naka::Strategies::CreateWeapon.new(user, [a, b, c, d]).start
    end

    get '/weapon/aircraft' do
      create_weapon(20, 60, 10, 210)
    end

    get '/weapon/cheap' do
      create_weapon(10, 10, 10, 10)
    end

    get '/quests' do
      quests = user.quests
      quests.each do |quest|
        user.complete_quest(quest.id) if quest.completable?
      end
      user.quests.to_json
    end

    get '/practice' do
      practices = user.api.practice.all
      practice = practices.detect{|x| !x.finished?}
      Naka::Strategies::Practice.new(user, practice).start
      :ok
    end

    get "/battle" do
      Naka::Strategies::Battle.new(user, params[:area], params[:map]).start
    end

    get '/battle/3-2-1' do
      Naka::Strategies::Battle.new(user, 3, 2, {:one => true}).start
    end

    get '/kira' do
      Naka::Strategies::Kira.new(user, params[:type]).start.to_json
    end

    def user
      User.first
    end
  end
end
