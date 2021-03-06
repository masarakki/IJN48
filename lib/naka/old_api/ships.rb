# -*- coding: utf-8 -*-
module Naka
  module OldApi
    module Ships
      def ships_master(reload = false)
        redis_key = "naka:master:ships"
        ships_master = Naka.redis.get(redis_key)

        ship_types = api.master.ship_type
        if !reload && ships_master
          ships_master = MessagePack.unpack(ships_master)
        else
          response = api.post "/kcsapi/api_get_master/ship"
          ships_master = response[:api_data].map do |ship|
            {
              id: ship[:api_id], name: ship[:api_name], type: ship_types.find(ship[:api_stype]).try(:name),
              fuel: ship[:api_fuel_max], bullet: ship[:api_bull_max]
            }
          end
          Naka.redis.set(redis_key, ships_master.to_msgpack)
        end
        ships_master.map { |ship| OpenStruct.new(ship) }
      end

      def ships
        ships = ships_master
        response = api.post "/kcsapi/api_get_member/ship2", api_sort_order: 2, api_sort_key: 1
        response[:api_data].map do |ship|
          master_ship = ships.detect{|master_ship| master_ship.id == ship[:api_ship_id] }
          unless master_ship
            ships = ships_master(true)
            master_ship = ships.detect{|master_ship| master_ship.id == ship[:api_ship_id] }
          end
          Naka::Models::Ship.new(ship.merge(api_master: master_ship))
        end
      end
    end
  end
end
