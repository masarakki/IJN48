require 'naka/api/master/base'
require 'naka/api/master/ship'
require 'naka/api/master/weapon'
require 'naka/api/master/map'
require 'naka/api/master/ship_type'
require 'naka/api/master/area'

module Naka
  module Api
    module Master
      class Manager < Naka::Api::Manager
        register :ship, Ship
        register :weapon, Weapon
        register :map, Map, true
        register :ship_type, ShipType, true
        register :area, Area, true
      end
      Naka::Api::Manager.register :master, Manager
    end
  end
end

