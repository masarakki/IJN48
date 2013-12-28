module Naka
  module Strategies
    class Practice < Base
      quest_ids 302, 303, 304

      def initialize(user, practice)
        @user = user
        @practice = practice
      end

      def run(quest_ids)
        fleet = user.fleets.first
        Naka::Strategies::Supply.new(user, fleet.ship_ids.compact).start
        battle = user.api.practice.battle(@practice)
        p [:our, battle.fleet_hps]
        p [:enemy, battle.enemy_hps]
        unless battle.completed?
          sleep 10
          user.api.practice.midnight(@practice)
        end
        sleep 10
        user.api.practice.result
      end
    end
  end
end
