module Naka
  module Models
    module Battle
      class Move
        attr_accessor :cell_id, :has_next, :boss_cell_id, :has_battle, :midnight_start

        def self.from_api(response)
          move = new
          data = response[:api_data]
          move.cell_id = data[:api_no]
          move.boss_cell_id = data[:api_bosscell_no]
          move.has_next = data[:api_next] != 0
          move.has_battle = data.has_key?(:api_enemy)
          move.midnight_start = data[:api_color_no] == 6
          move
        end

        def battle? ; has_battle ; end
        def skippable? ; !battle? ; end
        def boss? ; boss_cell_id == cell_id ; end
        def terminal? ; ! has_next ; end
        def midnight? ; midnight_start ; end
      end
    end
  end
end
