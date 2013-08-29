module Naka
  module OldApi
    module Docks
      def docks
        response = api.post "/kcsapi/api_get_member/ndock", api_verno: 1
        response[:api_data].map {|dock| Naka::Models::Dock.new(dock) }
      end
    end
  end
end
