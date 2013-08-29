module Naka
  module Api
    module Master
      class Weapon < Naka::Api::Master::Base
        cache 'weapons'
        endpoint 'slotitem'
      end
    end
  end
end
