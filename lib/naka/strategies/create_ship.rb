module Naka
  module Strategies
    class CreateShip < Base
      quest_ids 606, 608

      def initialize(user, materials)
        @user = user
        @materials = materials
      end

      def run(quest_ids)
        response = @user.api.factory.ship.create(*@materials)
        ship_id = response[:api_data][:api_ship_id]
        p @user.ships_master.detect{|ship| ship.id == ship_id}
      end
    end
  end
end
