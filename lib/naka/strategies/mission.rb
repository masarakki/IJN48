module Naka
  module Strategies
    class Mission < Base
      def initialize(user, mission_ids = [])
        @user = user
        @mission_ids = mission_ids
      end

      def fleets
        @fleets ||= user.fleets
      end

      def mission_ids
        @mission_ids - fleets.map{|fleet| fleet.mission.id if fleet.mission && !fleet.mission.finished? }
      end

      def ships
        @ships ||= user.ships
      end

      def run
        fleets.select(&:missionable?).zip(mission_ids).each do |fleet, mission_id|
          begin
            user.mission_result(fleet.id) if fleet.mission
            Naka::Strategies::Supply.new(user, fleet.ship_ids.compact).run
            user.start_mission(fleet.id, mission_id) if fleet && mission_id
          end
        end
      end
    end
  end
end
