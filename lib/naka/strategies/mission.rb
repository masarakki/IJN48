module Naka
  module Strategies
    class Mission < Base
      quest_ids 402, 403, 404

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

      def run(quest_ids)
        if fleets.any? {|fleet| fleet.mission && fleet.mission.finished? }
          user.api.post "/kcsapi/api_get_member/deck_port"
        end
        fleets.select(&:missionable?).zip(mission_ids).each do |fleet, mission_id|
          begin
            p "mission_result: fleet=#{fleet.id}, mission=#{fleet.mission.id}, result=#{user.mission_result(fleet.id)}" if fleet.mission
            ship_ids = Naka::Strategies::Organize.new(user, fleet.id, damaged: true).start
            Naka::Strategies::Supply.new(user, ship_ids.compact).start
            user.start_mission(fleet.id, mission_id) if fleet && mission_id
          end
        end
      end
    end
  end
end
