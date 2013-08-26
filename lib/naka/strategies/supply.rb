module Naka
  module Strategies
    class Supply < Base
      def initialize(user, ship_ids)
        @user = user
        @ship_ids = ship_ids
      end

      def run
        user.ships.select{|ship| @ship_ids.include?(ship.id) && ship.consumed? }.each do |ship|
          [:bullet, :fuel].each do |type|
            user.supply([ship.id], type) unless ship.master.send(type) == ship.send(type)
          end
        end
      end
    end
  end
end
