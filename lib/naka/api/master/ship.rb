module Naka
  module Api
    module Master
      class Ship < Naka::Api::Master::Base
        cache 'ships'
        endpoint 'ship'
      end
    end
  end
end
