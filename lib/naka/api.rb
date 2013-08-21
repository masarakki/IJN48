require 'naka/api/client'
require 'naka/api/ships'
require 'naka/api/docks'

module Naka
  class User
    include Naka::Api::Ships
    include Naka::Api::Docks

    def api
      @client ||= Naka::Api::Client.new(self)
    end
  end
end
