module Naka
  module Api
    module Factory
      def create_ship(fuel = 30, bullet = 30, iron = 30, bauxite = 30, cheat = true, dock_id = 1)
        api.post "/kcsapi/api_req_kousyou/createship", api_item1: fuel, api_item2: bullet, api_item3: iron, api_item4: bauxite, api_kdock_id: dock_id, api_highspeed: (cheat ? 1 : 0)
        get_new_ship(dock_id) if cheat
      end

      def get_new_ship(dock_id)
        api.post "/kcsapi/api_req_kousyou/getship", api_kdock_id: dock_id
      end
    end
  end
end
