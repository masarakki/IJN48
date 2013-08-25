require 'naka/api/client'
require 'naka/api/ships'
require 'naka/api/docks'
require 'naka/api/repair'
require 'naka/api/mission'

module Naka
  class User
    include Naka::Api::Ships
    include Naka::Api::Docks
    include Naka::Api::Repair
    include Naka::Api::Mission

    def api
      @client ||= Naka::Api::Client.new(self)
    end
  end
end
