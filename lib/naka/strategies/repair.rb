module Naka
  module Strategies
    class Repair < Base
      name 'Repiar'

      def ships
        @ships ||= user.ships
      end

      def docks
        @docks ||= user.docks
      end

      def fleets
        @fleets ||= user.fleets
      end

      def fleets_ship_ids
        fleets.map(&:ship_ids).flatten
      end

      def has_short?
        @has_short ||= docks.any? {|dock| dock.used? && dock.repairs_in < 30 * 60 }
      end

      def repairing_ship_ids
        docks.select(&:used?).map(&:ship_id)
      end

      def damaged_ships
        ships.select { |ship|
          ship.damaged? && !repairing_ship_ids.include?(ship.id)
        }.sort_by { |ship|
          [
            fleets_ship_ids.include?(ship.id) ? 1 : 0,
            has_short? ? - ship.repairs_in : ship.repairs_in
          ]
        }
      end

      def cheating
        user.ships.each do |ship|
          user.repair(ship, nil, true) if ship.repairs_in > cheat_if_over_it
        end
      end

      def cheat_if_over_it
        nil
      end

      def run
        return false unless docks.select(&:blank?)
        cheating if cheat_if_over_it
        docks.select(&:blank?).zip(damaged_ships).each do |dock, ship|
          user.repair(ship, dock) if dock && ship
        end
      end
    end
  end
end
