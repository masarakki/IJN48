module Naka
  module Models
    module Battle
      class Move
        attr_accessor :cell_id, :has_next, :boss_cell_id

        def self.from_api(response)
          move = new
          data = response[:api_data]
          move.cell_id = data[:api_no]
          move.boss_cell_id = data[:api_bosscell_no]
          move.has_next = data[:api_next] != 0
          move
        end

        def boss? ; boss_cell_id == cell_id ; end
        def terminal? ; ! has_next ; end
      end
    end
  end
end
