module Naka
  module Api
    class Ship < Base
      def merge(ship_id, merge_ids)
        request '/kcsapi/api_req_kaisou/powerup', api_id: ship_id, api_id_items: merge_ids.join(",")
      end

      def destroy(ship_id)
        request '/kcsapi/api_req_kousyou/destroyship', api_ship_id: ship_id
      end

      def upgrade(ship_id)
        request '/kcsapi/api_req_kaizou/remodeling', api_id: ship_id
      end
    end

    Manager.register :ship, Ship
  end
end
