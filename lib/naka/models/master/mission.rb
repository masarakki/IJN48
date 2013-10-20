module Naka
  module Models
    module Master
      class Mission < Naka::Models::Base

        Reward = Struct.new(:fuel, :bullet, :steel, :bauxite, :repair)
        Cost = Struct.new(:fuel, :bullet)

        attr_accessor :time, :reward, :cost, :fleet

        def initialize(options = {})
          @id = options[:id]
          @cost = Cost.new *options[:cost] || [0, 0]
          @reward = Reward.new(0, 0, 0, 0, 0).tap do |reward|
            options[:reward].each_pair {|k, v| reward.send("#{k}=", v) } if options[:reward]
          end
          @time = options[:time]
          @fleet = options[:fleet]
        end

        def self.setup(&block)
          self.instance_exec &block if block_given?
        end
      end
    end
  end
end

Naka::Models::Master::Mission.setup do
  register id:  1, time:  15, cost: [0.3, 0.0], reward: {bullet: 30}, fleet: {any: 2}
  register id:  2, time:  30, cost: [0.5, 0.0], reward: {bullet: 100, steel: 30, repair: 1}, fleet: {any: 4}
  register id:  3, time:  20, cost: [0.3, 0.2], reward: {fuel: 30, bullet: 30, steel: 40}, fleet: {any: 3}
  register id:  4, time:  50, cost: [0.5, 0.0], reward: {bullet: 60, repair: 1}, fleet: {cl: 1, dd: 2}
  register id:  5, time:  90, cost: [0.5, 0.0], reward: {fuel: 200, bullet: 200, steel: 20, bauxite: 20}, fleet: {cl: 1, dd: 2, any: 1}
  register id:  6, time:  40, cost: [0.3, 0.2], reward: {bauxite: 80}, fleet: {any: 4}
  register id:  7, time:  60, cost: [0.5, 0.0], reward: {steel: 50, bauxite: 30}, fleet: {any: 6}
  register id:  8, time: 180, cost: [0.5, 0.2], reward: {fuel: 50, bullet: 100, steel: 50, bauxite: 50}, fleet: {any: 6}
  register id:  9, time: 240, cost: [0.5, 0.0], reward: {fuel: 350, repair: 2}, fleet: {cl: 1, dd:2, any: 1}
  register id: 10, time:  90, cost: [0.3, 0.0], reward: {bullet: 50, bauxite: 30, repair: 1}, fleet: {cl: 2, any: 1}
  register id: 11, time: 300, cost: [0.5, 0.0], reward: {bauxite: 250, repair: 1}, fleet: {dd: 2, any: 2}
  register id: 12, time: 480, cost: [0.5, 0.0], reward: {fuel: 50, bullet: 250, steel: 200, bauxite: 50}, fleet: {dd: 2, any: 2}
  register id: 13, time: 240, cost: [0.5, 0.4], reward: {fuel: 240, bullet: 300, repair: 2}, fleet: {cl: 1, dd:4, any: 1}
  register id: 14, time: 360, cost: [0.5, 0.0], reward: {bullet: 240, steel: 200, repair: 1}, fleet: {cl: 1, dd: 3, any: 2}
  register id: 15, time: 720, cost: [0.5, 0.4], reward: {steel: 300, bauxite: 400}, fleet: {cl: 2, dd: 2, any: 2}
  register id: 16, time: 900, cost: [0.5, 0.4], reward: {fuel: 500, bullet: 500, steel: 200, bauxite: 200, repair: 2}, fleet: {cl: 1, dd: 2, any: 3}

end
