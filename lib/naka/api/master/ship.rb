# -*- coding: utf-8 -*-
module Naka
  module Api
    module Master
      class Ship < Naka::Api::Master::Base
        cache 'ships'
        endpoint 'ship'
      end
    end
  end
end

=begin
def ships_master
  redis_key = "naka:master:ships"
  ships_master = Naka.redis.get(redis_key)

  if ships_master
    ships_master = MessagePack.unpack(ships_master)
  else
    types = {
      2 => '駆逐艦',
      3 => '軽巡洋艦',
      4 => '重雷装巡洋艦',
      5 => '重巡洋艦',
      6 => '航空巡洋艦',
      7 => '軽空母',
      8 => '戦艦',
      9 => '戦艦',
      10 => '航空戦艦',
      11 => '空母',
      13 => '潜水艦',
      14 => '潜水母艦'
    }
    response = api.post "/kcsapi/api_get_master/ship"
    ships_master = response[:api_data].map do |ship|
      {
        id: ship[:api_id], name: ship[:api_name], type: types[ship[:api_stype]],
        fuel: ship[:api_fuel_max], bullet: ship[:api_bull_max]
      }
    end
    Naka.redis.set(redis_key, ships_master.to_msgpack)
  end
  ships_master.map { |ship| OpenStruct.new(ship) }
end
=end
