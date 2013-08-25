module Naka
  module Api
    module Fleets
      def fleets
        response = api.post "/kcsapi/api_get_member/deck"
        response[:api_data].map{|deck| Naka::Models::Fleet.from_api(deck) }
      end
    end
  end
end
