module Naka
  module Api
    module Ships
      def ships
        response = api.post "/kcsapi/api_get_member/ship2", api_sort_order: 2, api_sort_key: 1, api_verno: 1
        {
          ships: response[:api_data].map {|ship| Naka::Models::Ship.new(ship) },
          groups: response[:api_data_deck]
        }
      end
    end
  end
end
