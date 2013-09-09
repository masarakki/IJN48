module Naka
  module Api
    class Battle < Base
      def map(area_id, map_no)
        response = request '/kcsapi/api_get_master/mapcell', api_maparea_id: area_id, api_mapinfo_no: map_no
        Naka::Models::Battle::Map.from_api(response)
      end

      def start(area_id, area_no, deck_id = 1, formation_id = 1)
        response = request '/kcsapi/api_req_map/start', api_formation_id: formation_id, api_deck_id: deck_id, api_maparea_id: area_id, api_mapinfo_no: area_no
        Naka::Models::Battle::Move.from_api(response)
      end

      def battle(formation = 1)
        request '/kcsapi/api_req_sortie/battle', api_formation: formation
      end

      def midnight
        request '/kcsapi/api_req_battle_midnight/battle'
      end

      def result
        request '/kcsapi/api_req_sortie/battleresult'
      end

      def next
        response = request '/kcsapi/api_req_map/next'
        Naka::Models::Battle::Move.from_api(response)
      end
    end

    Manager.register :battle, Battle
  end
end
