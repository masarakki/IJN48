module Naka
  module Strategies
    class CreateWeapon < Base
      quest_ids 605, 607

      def initialize(user, materials)
        @user = user
        @materials = materials
      end

      def run(quest_ids)
        response = @user.api.factory.weapon.create(*@materials)
        if response[:api_data][:api_create_flag] == 0
          p :fail
        else
          weapon_id = response[:api_data][:api_slotitem_id]
          p @user.api.factory.weapon.find(weapon_id).api_name
        end
      end
    end
  end
end
