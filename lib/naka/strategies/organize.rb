module Naka
  module Strategies
    class Organize < Base
      attr_reader :user, :fleet_id, :size, :types, :damaged
      def initialize(user, fleet_id = 1, options = {})
        @user = user
        @fleet_id = fleet_id
        @size = options[:size] || 1
        @types = options[:types] || []
        @damaged = options[:damaged] || false
      end

      def run(quest_ids)
        @fleet = @user.fleets.detect{|x| x.id == @fleet_id}
        raise 'under mission' if @fleet.mission

        if @damaged
          change_abnormal
        else
          change_normal
        end
      end

      def user_ships
        @user_ships ||= user.ships
      end

      def fleet_ships
        @fleet.ship_ids.map{|ship_id| user_ships.detect{|x| x.id == ship_id} }.compact
      end

      def using_ship_ids
        @using_ship_ids ||= user.fleets.map{|x| x.ship_ids}.flatten.compact
      end

      def change_abnormal
        fleet_ship_names = fleet_ships.map(&:pure_name)
        fleet_ship_ids = fleet_ships.map(&:id)
        fleet_ships.each_with_index do |ship, index|
          if ship && ship.tired?
            other_names = fleet_ship_names - [ship.pure_name]
            type = ship.master.type
            candidate = user_ships.select do |can|
              !using_ship_ids.include?(can.id) &&
                can.locked? && can.master.type == type &&
                !can.tired? && !other_names.include?(can.pure_name)
            end.sample
            raise unless candidate
            user.api.deck.change(@fleet_id, index, candidate.id)
            fleet_ship_ids -= [ship.id]
            fleet_ship.ids += [can.id]
            fleet_ship_names = other_names + [candidate.pure_name]
          end
        end
        fleet_ship_ids
      end

      def change_normal
        fleet_ship_names = fleet_ships.map(&:pure_name)
        fleet_ships.each_with_index do |ship, index|
          if ship && ship.danger?
            other_names = fleet_ship_names - [ship.pure_name]
            type = ship.master.type
            candidate = user_ships.select do |can|
              !using_ship_ids.include?(can.id) &&
                can.locked? && can.master.type == type &&
                !can.danger? && !other_names.include?(can.pure_name)
            end.sample
            raise unless candidate
            user.api.deck.change(@fleet_id, index, candidate.id)
            fleet_ship_names = other_names + [candidate.pure_name]
          end
        end
        fleet_ship_names
      end
    end
  end
end
