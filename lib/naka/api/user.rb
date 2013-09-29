require 'naka/api/user/practice'
require 'naka/api/user/ship'

module Naka
  module Api
    module User
      class Manager < Naka::Api::Manager
        register :practice, Practice
        register :ship, Ship
      end
    end
  end
end
