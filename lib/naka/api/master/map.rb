module Naka
  module Api
    module Master
      class Map < Naka::Api::Master::Base
        cache 'map'
        endpoint 'mapcell'
        args :maparea_id, :mapinfo_no

        def find(area_id, map_no)
          response = request '/kcsapi/api_get_master/mapcell', api_maparea_id: area_id, api_mapinfo_no: map_no
          Naka::Models::Battle::Map.from_api(response)
        end
      end
    end
  end
end
