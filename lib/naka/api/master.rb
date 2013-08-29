require 'naka/api/master/base'
require 'naka/api/master/ship'
require 'naka/api/master/weapon'

module Naka
  module Api
    module Master
      class Manager < Naka::Api::Manager
        register :ship, Ship
        register :weapon, Weapon
      end
      Naka::Api::Manager.register :master, Manager
    end
  end
end

