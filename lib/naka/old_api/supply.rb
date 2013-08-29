module Naka
  module OldApi
    module Supply
      def supply(ship_ids, kind = :both)
        kind = {fuel:1, bullet: 2, both: 3}[kind]
        api.post '/kcsapi/api_req_hokyu/charge', api_id_items: ship_ids.join(','), api_kind: kind
      end
    end
  end
end
