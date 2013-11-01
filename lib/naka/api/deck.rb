module Naka
  module Api
    class Deck < Base
      def change(deck_id, index, ship_id)
        request '/kcsapi/api_req_hensei/change', api_ship_id: ship_id, api_ship_idx: index, api_id: deck_id
        request '/kcsapi/api_get_member/deck'
      end

      def remove(deck_id, index)
        change(deck_id, index, -1)
        request '/kcsapi/api_get_member/deck'
      end
    end
    Manager.register :deck, Deck
  end
end
