module Naka
  module Api
    class Deck < Base

      # index: zero origin
      def change(deck_id, index, ship_id)
        request '/kcsapi/api_req_hensei/change', api_ship_id: ship_id, api_ship_idx: index, api_id: deck_id
      end

      # index: zero origin
      def remove(deck_id, index)
        change(deck_id, index, -1)
      end

      def organize(fleet_id, ships)
        fleet = user.fleets[fleet_id - 1]
        (fleet.ship_ids.size - ships.size).times { remove(fleet_id, ships.size) }
        ships.each_with_index do |ship, index|
          if ship.is_a? Integer
            change(fleet_id, index, ship)
          else
            change(fleet_id, index, ship.id)
          end
        end
        ships
      end
    end
    Manager.register :deck, Deck
  end
end
