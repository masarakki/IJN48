require 'naka/api/client'
require 'naka/api/ships'
require 'naka/api/fleets'
require 'naka/api/docks'
require 'naka/api/repair'
require 'naka/api/mission'
require 'naka/api/supply'
require 'naka/api/factory'

module Naka
  class User
    include Naka::Api::Ships
    include Naka::Api::Docks
    include Naka::Api::Repair
    include Naka::Api::Mission
    include Naka::Api::Fleets
    include Naka::Api::Supply
    include Naka::Api::Factory

    def api
      @client ||= Naka::Api::Client.new(self)
    end
  end
end
