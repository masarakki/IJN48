# -*- coding: utf-8 -*-
module Naka
  module Strategies
    class MissionOrganize < Base
      attr_reader :user, :fleet_id, :mission
      def initialize(user, fleet_id = 1, mission)
        @user = user
        @fleet_id = fleet_id
        @mission = mission
      end

      def run(quest_ids)
        @fleet = @user.fleets.detect{|x| x.id == @fleet_id}
        raise 'under mission' if @fleet.mission
        organize
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

      def other_fleet_ship_ids
        @other_fleet_ship_ids ||= using_ship_ids - fleet_ships.map(&:id)
      end

      def repairing_ship_ids
        @repairing_ship_ids ||= user.docks.map(&:ship_id).compact
      end

      def usable_ships
        return @usable_ships if @usable_ships
        reject_ship_ids = repairing_ship_ids + other_fleet_ship_ids
        @usable_ships = user_ships.reject do |ship|
          reject_ship_ids.include?(ship.id) || ship.tired?
        end
      end

      def type_mappings
        @type_mappings ||= {
          dd:  %w{駆逐艦},
          cl:  %w{軽巡洋艦},
          ca:  %w{重巡洋艦},
          cv:  %w{軽空母 水上機母艦 潜水空母},
          acv: %w{水上機母艦},
          bbv: %w{航空戦艦},
          cav: %w{航空巡洋艦},
          ss:  %w{潜水艦},
          any: %w{駆逐艦 軽巡洋艦 水上機母艦 潜水艦 軽空母}
        }
      end

      def organize
        fleet_ship_names = fleet_ships.map(&:pure_name)
        fleet_ship_ids = fleet_ships.map(&:id)
        ship_stats = user.api.master.ship_type.inject({}) do |res, type|
          res[type.name] = {total: 0, danger: 0, fatal: 0, high: 0, use_danger: false}
          res
        end
        ship_stats = usable_ships.inject(ship_stats) do |res, ship|
          type = ship.master.type
          res[type][:total] += 1
          res[type][:danger] += 1 if ship.hp.danger? && !ship.hp.fatal?
          res[type][:fatal] += 1 if ship.hp.fatal?
          res[type][:use_danger] = true if res[type][:danger] + res[type][:fatal] > 4
          res[type][:high] += 1 if ship.high? && !ship.hp.fatal?
          res
        end

        use_high = mission.fleet.each_pair.all? do |type, num|
          types = type_mappings[type]
          types.map {|type_str| ship_stats[type_str][:high] }.sum >= num
        end
        candidates = []
        mission.fleet.each_pair.map do |type, num|
          types = type_mappings[type]
          candidates_for_type = usable_ships.select { |ship|
            types.include?(ship.master.type) &&
            !candidates.include?(ship) &&
            (use_high ? ship.high? : true) &&
            (ship_stats[ship.master.type][:use_danger] ? !ship.hp.fatal? : !ship.hp.danger?)
          }.sort_by{ |ship| [ship.hp.danger? ? 0 : 1, ship.master.fuel, ship.master.bullet]}.take(num)
          raise unless candidates_for_type.size == num
          candidates += candidates_for_type
        end

        (fleet_ships.size - candidates.size).times { user.api.deck.remove(fleet_id, candidates.size) }
        candidates.each_with_index do |ship, index|
          user.api.deck.change(fleet_id, index, ship.id)
        end
        candidates
      end
    end
  end
end
