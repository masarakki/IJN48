module Naka
  module Models
    module Battle
      class Move
        attr_accessor :cell_id, :has_next, :boss_cell_id, :has_battle, :battle_type, :midnight_start, :night_to_day

        def self.from_api(response)
          move = new
          data = response[:api_data]
          move.cell_id = data[:api_no]
          move.boss_cell_id = data[:api_bosscell_no]
          move.has_next = data[:api_next] != 0
          move.has_battle = data.has_key?(:api_enemy)
          move.battle_type = case data[:api_color_no]
                             when 6 then :midnight_start
                             when 8 then :night_to_day
                             else :normal
                             end
          move
        end

        def battle? ; has_battle ; end
        def skippable? ; !battle? ; end
        def boss? ; boss_cell_id == cell_id || night_to_day? ; end
        def terminal? ; ! has_next ; end
        def midnight? ; battle_type == :midnight_start ; end
        def night_to_day? ; battle_type == :night_to_day ; end
      end
    end
  end
end
