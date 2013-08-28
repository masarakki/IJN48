module Naka
  module Api
    class Factory < Naka::Api::Manager
      Naka::Api::Manager.register(:factory, self)

      class Ship < Naka::Api::Base
        def create(fuel = 30, bullet = 30, iron = 30, bauxite = 30, cheat = true, dock_id = 1)
          request "/kcsapi/api_req_kousyou/createship", api_item1: fuel, api_item2: bullet, api_item3: iron, api_item4: bauxite, api_kdock_id: dock_id, api_highspeed: (cheat ? 1 : 0)
          get(dock_id) if cheat
        end

        def get(dock_id)
          request "/kcsapi/api_req_kousyou/getship", api_kdock_id: dock_id
        end
      end

      register :ship, Ship
    end
  end
end
