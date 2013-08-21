module Naka
  module Models
    class Ship
      attr_accessor :id, :ship_id, :lv, :hp
      def initialize(options = {})
        options.each_pair do |key, value|
          key = key.to_s.gsub /api_/, ''
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end
    end
  end
end
