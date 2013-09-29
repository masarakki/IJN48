module Naka
  module Models
    module Master
      class Ship < Naka::Models::Base
        attr_accessor :name
        def initialize(options = {})
          @id = options[:id]
          @name = options[:name]
        end

        def self.from_api(response)
          response[:api_data].each do |data|
            self.register(id: data[:api_id], name: data[:api_name])
          end
        end
      end
    end
  end
end
