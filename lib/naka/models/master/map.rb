module Naka
  module Models
    module Master
      class Map
        attr_accessor :map_id, :area_id, :cells

        Cell = Struct.new(:id, :type) do
          def start? ; type == 0 ; end
          def battle? ; boss? || type == 4 ; end
          def trap? ; type == 3 ; end
          def item? ; type == 2 ; end
          def boss? ; type == 5 ; end
          def unknown? ; !(start? || battle? || trap? || item? || boss?) ; end
        end

        def self.from_api(res)
          map = new
          res[:api_data].first.tap do |x|
            map.map_id = x[:api_maparea_id]
            map.area_id = x[:api_mapinfo_no]
          end

          map.cells = res[:api_data].map do |x|
            Cell.new(x[:api_no], x[:api_color_no])
          end
          map
        end

        def find(id)
          cells.detect {|x| x.id == id}
        end
      end
    end
  end
end
