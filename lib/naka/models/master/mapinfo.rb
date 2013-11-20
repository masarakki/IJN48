module Naka
  module Models
    module Master
      class MapInfo < Naka::Models::Base
        attr_accessor :id, :area_id, :map_id, :name

        def initialize(attrs = {})
          @id = attrs[:id]
          @area_id = attrs[:area_id]
          @map_id = attrs[:map_id]
          @name = attrs[:name]
          @enabled = attrs[:enabled] || false
          @cleared = attrs[:cleared] || false
          @boss_hp = attrs[:boss_hp] || nil
        end

        def enabled? ; @enabled ; end
        def cleared? ; @cleared ; end
        def event_boss? ; @boss_hp.present? ; end

        def self.from_api(response)
          response[:api_data].each do |data|
            register id: data[:api_id], name: data[:api_name], area_id: data[:api_maparea_id], map_id: data[:api_no], enabled: data[:api_active] == 1, cleared: data[:api_cleared] == 1, boss_hp: data[:api_eventmap]
          end
          self
        end
      end
    end
  end
end
