require 'naka/api/master/base'
require 'naka/api/master/ship'
require 'naka/api/master/weapon'
require 'naka/api/master/map'
require 'naka/api/master/ship_type'

module Naka
  module Api
    module Master
      class Manager < Naka::Api::Manager
        register :ship, Ship
        register :weapon, Weapon
        register :map, Map, true
        register :ship_type, ShipType, true
      end
    end
  end
end

