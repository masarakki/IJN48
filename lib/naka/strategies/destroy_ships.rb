module Naka
  module Strategies
    class DestroyShips < Base
      quest_ids 609
      def initialize(user)
        @user = user
      end

      def run(quest_ids)
        user.ships.select{|x| !x.locked? }.each do |ship|
          user.api.ship.destroy(ship.id)
        end
      end
    end
  end
end
