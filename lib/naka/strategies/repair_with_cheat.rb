require 'naka/strategies/repair'

module Naka
  module Strategies
    class RepairWithCheating < Repair
      def cheat_if_over_it
        60 * 60 * 3
      end
    end
  end
end
