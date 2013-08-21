require 'naka/api/client'
require 'naka/api/ships'

module Naka
  class User
    include Naka::Api::Ships

    def api
      @client ||= Naka::Api::Client.new(self)
    end
  end
end
