module Naka
  module Models
    module Master
      ShipType = Struct.new(:id, :name) do
        def self.from_api(response)
          collection = Collection.new
          response[:api_data].each do |data|
            collection << ShipType.new(data[:api_id], data[:api_name])
          end
          collection
        end
      end
    end
  end
end
