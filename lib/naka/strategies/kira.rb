# -*- coding: utf-8 -*-
=begin
201: 敵艦隊を撃破
210: 敵艦隊10回
214: あ号
216: 敵艦隊主力
=end

module Naka
  module Strategies
    class Kira < Base
      quest_ids 201, 210, 214, 216
      attr_accessor :map, :ship, :targets

      def initialize(user, type = :dd)
        @user = user
        @map = @user.api.master.map(1, 1)
        @targets = target_ship_types(type)
        @ship = candidate_ships.sample
      end

      def finish(string)
        user.api.battle.finish
        string
      end

      def target_ship_types(type)
        ids = case type.to_sym
              when :ss
                [13, 14]
              when :dd
                [2]
              when :cl
                [3]
              when :tc
                [4]
              when :ca
                [5, 6]
              when :cv
                [6, 7, 10, 11]
              when :lcv
                [6, 7, 16]
              when :bb
                [8, 9, 10, 12]
              end
        user.api.master.ship_type.select{|x| ids.include?(x.id) }.map(&:name)
      end

      def candidate_ships
        ships_under_mission = user.fleets.select{|fleet| fleet.mission? }.map(&:ship_ids)
        ships_in_dock = user.docks.map(&:ship_id)
        exclude_ship_ids = (ships_under_mission + ships_in_dock).flatten.compact.uniq
        user.ships.select {|ship| targets.include?(ship.type) && !ship.high? && !ship.bad? && !ship.hp.danger? && ship.locked? && !exclude_ship_ids.include?(ship.id) }
      end

      def battle
        Naka::Strategies::Supply.new(user, [ship.id]).start
        move = user.api.battle.start(1, 1)
        loop do
          if move.battle?
            battle = user.api.battle.battle
            sleep 10
            result = user.api.battle.result
            return finish("損傷撤退" ) if battle.fleet_hps.any? {|x| (x.first.to_f / x.last) <= 0.5 }
          end
          return finish("完了") if move.terminal?
          move = user.api.battle.next unless move.terminal?
          sleep 5
        end
      end

      def update_ship
        @ship = user.ships.detect{|x| x.id == ship.id}
        @ship
      end

      def run(mission_ids)
        if ship
          user.api.deck.organize(1, [ship])
          condition = ship.condition
          times = 1
          loop do
            before_condition = condition
            battle
            condition = update_ship.condition
            return result(:failure, times) if ship.hp.fatal?
            return result(:failure, times) unless condition > before_condition
            return result(:success, times) if condition > 70
            times += 1
          end
        end
      end

      def result(code, times)
        {
          status: code,
          ship: {
            name: ship.name,
            condition: ship.condition
          },
          times: times
        }
      end
    end
  end
end
