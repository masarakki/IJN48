module Naka
  module OldApi
    module Repair
      def repair(ship, dock = nil, cheat = false)
        dock = docks.detect(&:blank?) unless dock
        raise unless dock
        api.post '/kcsapi/api_req_nyukyo/start', api_ship_id: ship.id, api_ndock_id: dock.id, api_highspeed: 0, api_verno: 1, api_highspeed: (cheat ? 1 : 0)
      end

      def finish_repair(dock)
        api.post '/kcsapi/api_req_nyukyo/speedchange', api_ndock_id: dock.id
      end
    end
  end
end
