module Naka
  module Api
    module Mission
      def start_mission(deck_id, mission_id)
        api.post '/kcsapi/api_req_mission/start', api_deck_id: deck_id, api_mission_id: mission_id
      end
    end
  end
end
