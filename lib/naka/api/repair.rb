module Naka
  module Api
    module Repair
      def repair(ship, dock = nil)
        dock = docks.select(&:blank?) unless dock
        raise unless dock
        api.post '/kcsapi/api_req_nyukyo/start', api_ship_id: ship.id, api_ndock_id: dock.id, api_highspeed: 0, api_verno: 1
      end
    end
  end
end
