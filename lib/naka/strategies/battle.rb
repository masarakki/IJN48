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

      def finish(string)
        @user.api.battle.finish
        string
      end

      def run(mission_ids)
        ships = Naka::Strategies::Organize.new(@user, 1).start
        Naka::Strategies::Supply.new(@user, ships.map(&:id)).start
        p ships.map{|x| x.master.name }
        move = @user.api.battle.start(@map.map_id, @map.area_id)

        loop do
          if move.battle?
            p [:boss?, move.boss?]
            case
            when move.midnight?
              battle = @user.api.battle.midnight_battle(@options[:formation] || 1)
            when move.night_to_day?
              battle = @user.api.battle.night_to_day(@options[:formation] || 1)
            else
              battle = @user.api.battle.battle(@options[:formation] || 1)
              if battle.enemy_hps.first.last > 150 && battle.enemy_hps.first.first > 0
                battle = @user.api.battle.midnight
              end
            end
            result = @user.api.battle.result
            p [:fleet, battle.fleet_hps]
            p [:enemy, battle.enemy_hps]
            fleet = user.fleets.first
            update_ships = user.ships
            ships = ships.map { |ship| update_ships.detect{|x| x.id == ship.id} }
            return finish("損傷撤退" ) if ships.any?(&:danger?)
          else
            p :skip
          end
          return finish("予定撤退") if @options[:one]
          return finish("完了") if move.terminal?
          move = @user.api.battle.next unless move.terminal?
        end
      end
    end
  end
end
