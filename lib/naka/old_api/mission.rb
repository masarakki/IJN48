module Naka
  module OldApi
    module Mission
      def start_mission(deck_id, mission_id)
        api.post '/kcsapi/api_req_mission/start', api_deck_id: deck_id, api_mission_id: mission_id
      end

      def mission_result(deck_id)
        api.post '/kcsapi/api_req_mission/result', api_deck_id: deck_id
      end
    end
  end
end
