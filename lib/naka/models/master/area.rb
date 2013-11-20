module Naka
  module Models
    module Master
      class Area < Naka::Models::Base
        attr_accessor :id, :name, :type

        def initialize(attr = {})
          @id = attr[:id]
          @name = attr[:name]
          @type = attr[:type]
        end

        def event_area?
          type == 1
        end

        def self.from_api(response)
          response[:api_data].each do |data|
            register id: data[:api_id], name: data[:api_name], type: data[:api_type]
          end
          self
        end
      end
    end
  end
end
