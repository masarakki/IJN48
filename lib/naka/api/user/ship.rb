module Naka
  module Api
    module User
      class Ship < Naka::Api::Base
        def all
          p user.api.master.ship.all
          response = request "/kcsapi/api_get_member/ship2", api_sort_order: 2, api_sort_key: 1
          response[:api_data].map do |ship|
#            master_ship = ships.detect{|master_ship| master_ship.id == ship[:api_ship_id] }
#            Naka::Models::Ship.new(ship.merge(api_master: master_ship))
          end
        end
      end
    end
  end
end
