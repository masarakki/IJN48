module Naka
  class Command
    @queue = :ijn48

    def self.enqueue(strategy, user, *args)
      Resque.enqueue(self, strategy, user, *args)
    end

    def self.perform(strategy, user_hash, *args)
      strategy = "Naka::Strategies::#{strategy}".constantize
      user = User.new(user_hash.symbolize_keys)
      p strategy.new(user, *args).start.to_json
    end
  end
end

