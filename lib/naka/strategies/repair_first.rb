require 'naka/strategies/repair'

module Naka
  module Strategies
    class RepairFirst < Repair
      def run(quest_ids)
        docks.select(&:used?).each do |dock|
          user.finish_repair dock
        end
        user.docks
      end
    end
  end
end
