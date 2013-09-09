# -*- coding: utf-8 -*-
=begin
213: 海上通商破壊
214: あ号
220: い号
226: 南海諸島制海権
228: 海上護衛戦
230: 潜水艦
=end

module Naka
  module Strategies
    class Battle < Base
      quest_ids 213, 214, 220, 226, 228, 230

      def initialize(user, map_id, area_id)
        @user = user
        @map = @user.api.battle.map(map_id, area_id)
      end

      def run(mission_ids)
        move = @user.api.battle.start(@map.map_id, @map.area_id)
        Naka::Strategies::Supply.new(@user, @user.fleets.first.ship_ids.compact).start

        loop do
          cell = @map.find(move.cell_id)
          p [:boss?, cell.boss?]
          if cell.battle?
            battle = @user.api.battle.battle(1)
            result = @user.api.battle.result
            return if move.terminal?
            move = @user.api.battle.next unless move.terminal?
            p :continue
          end
        end
      end
    end
  end
end