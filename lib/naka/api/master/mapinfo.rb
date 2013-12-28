module Naka::Api::Master
  class MapInfo < Base
    cache 'mapinfo', 1500
    endpoint 'mapinfo'
  end
end
