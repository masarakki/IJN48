module Naka
  module Strategies
    class Supply < Base
      quest_ids 504

      def initialize(user, ship_ids)
        @user = user
        @ship_ids = ship_ids
      end

      def run(quest_ids)
        ships = user.ships.select{|ship| @ship_ids.include?(ship.id) && ship.consumed? }

        if quest_ids.count > 0
          ships.each do |ship|
            [:bullet, :fuel].each do |type|
              user.supply([ship.id], type) unless ship.master.send(type) == ship.send(type)
            end
          end
        else
          user.supply(ships.map(&:id)) if ships.count > 0
        end
      end
    end
  end
end
