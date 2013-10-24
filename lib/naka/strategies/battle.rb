# -*- coding: utf-8 -*-
=begin
201: 敵艦隊を撃破
210: 敵艦隊10回
211: 敵空母3隻
213: 海上通商破壊
214: あ号
216: 敵艦隊主力
218: 敵補給艦3隻
220: い号
221: ろ号
226: 南海諸島制海権
228: 海上護衛戦
229: 東方艦隊
230: 潜水艦6隻
=end

module Naka
  module Strategies
    class Battle < Base
      quest_ids 201, 210, 211, 213, 214, 216, 218, 220, 221, 226, 228, 229, 230

      def initialize(user, map_id, area_id, options = {})
        @user = user
        @map = @user.api.master.map(map_id, area_id)
        @options = options
      end

      def run(mission_ids)
        Naka::Strategies::Organize.new(@user, 1).start
        move = @user.api.battle.start(@map.map_id, @map.area_id)
        Naka::Strategies::Supply.new(@user, @user.fleets.first.ship_ids.compact).start
        user_ships = @user.ships
        p @user.fleets.first.ship_ids.compact.map{|x| user_ships.detect{|ship| ship.id == x}.master.name }
        loop do
          if move.battle?
            p [:boss?, move.boss?]
            if move.midnight?
              battle = @user.api.battle.midnight_battle(@options[:formation] || 1)
            else
              battle = @user.api.battle.battle(@options[:formation] || 1)
            end
            result = @user.api.battle.result
            return "損傷撤退" if battle.fleet_hps.any? {|x| (x.first.to_f / x.last) <= 0.5 }
          else
            p :skip
          end
          return "予定撤退" if @options[:one]
          return "完了" if move.terminal?
          move = @user.api.battle.next unless move.terminal?
        end
      end
    end
  end
end
