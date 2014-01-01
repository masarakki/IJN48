module Naka
  module Strategies
    class Mission < Base
      quest_ids 402, 403, 404

      def initialize(user)
        @user = user
      end

      def fleets
        @fleets ||= user.fleets
      end

      def candidates
        unless @candidates
          @candidates = missions.reject do |mission|
            fleets.map{|fleet| fleet.mission.id if fleet.mission && !fleet.mission.finished? }.include?(mission.id)
          end
        end
        @candidates
      end

      def ships
        @ships ||= user.ships
      end

      def missions
        unless @missions
          materials = user.api.status.materials
          material_keys = [:fuel, :bullet, :steel, :bauxite, :repair]
          candidates = Naka::Models::Master::Mission
          candidates = candidates.select{|x| x.time <= 90 } if @accept_ids && @accept_ids.length > 0

          sum =  materials.select{|x| x.material?}.sum(&:counter)
          ratio = material_keys.inject({}) do |res, key|
            res[key] = (materials.send(key).counter + 1.0) / sum
            res[key] *= 100 if key == :repair
            res
          end
          @missions = candidates.sort_by { |mission|
            material_keys.map { |material_id|
              mission.reward.send(material_id) / ratio[material_id]
            }.sum / mission.time
          }.reverse[0, 3]
        end
        @missions
      end

      def run(quest_ids)
        if fleets.any? {|fleet| fleet.mission && fleet.mission.finished? }
          user.api.post "/kcsapi/api_get_member/deck_port"
        end
        fleets.select(&:missionable?).zip(candidates).each do |fleet, mission|
          begin
            p "mission_result: fleet=#{fleet.id}, mission=#{fleet.mission.id}, result=#{user.mission_result(fleet.id)}" if fleet.mission
            ships = Naka::Strategies::MissionOrganize.new(user, fleet.id, mission).start
            Naka::Strategies::Supply.new(user, ships.map(&:id).compact).start
            user.start_mission(fleet.id, mission.id) if fleet && mission.id
          end
        end
      end
    end
  end
end
