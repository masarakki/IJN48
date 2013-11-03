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
      attr_accessor :map, :ship

      def initialize(user, target = '駆逐艦')
        @user = user
        @map = @user.api.master.map(1, 1)
        @ship = user.ships.detect{|ship| ship.type == target && !ship.high? && !ship.hp.fatal?}
      end

      def finish(string)
        user.api.battle.finish
        string
      end

      def battle
        Naka::Strategies::Supply.new(user, [ship.id]).start
        move = user.api.battle.start(1, 1)
        loop do
          if move.battle?
            battle = user.api.battle.battle
            result = user.api.battle.result
            return finish("損傷撤退" ) if battle.fleet_hps.any? {|x| (x.first.to_f / x.last) <= 0.5 }
          end
          return finish("完了") if move.terminal?
          move = user.api.battle.next unless move.terminal?
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
            return result(:failure, times) if condition < before_condition
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
