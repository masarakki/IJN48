module Naka
  module Models
    class Fleet
      attr_accessor :id, :name, :mission, :ship_ids, :ships

      Mission = Struct.new(:id, :finish_at) do
        def finished?
          finish_at < Time.now
        end

        def to_json(options = {})
          {id: id, finish_at: finish_at, finish_in: finish_at - Time.now}.to_json(options)
        end
      end

      def self.from_api(response)
        fleet = self.new
        response.each_pair do |key, value|
          key = key.to_s.gsub /api_/, ''
          fleet.send("#{key}=", value) if fleet.respond_to?("#{key}=")
        end
        fleet
      end

      def ship=(val) ; self.ship_ids = val.map{|x| x == -1 ? nil : x } ; end

      def mission=(val)
        @mission = Mission.new(val[1], Time.at(val[2] / 1000)) unless val == [0, 0, 0, 0]
      end

      def missionable?
        id != 1 && (mission.nil? || mission.finished?)
      end

      def length
        @ship_ids.compact.length
      end
    end
  end
end

