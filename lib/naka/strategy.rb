module Naka
  module Strategies
    class Base
      attr_reader :user

      def self.name(name)
        define_method(:name) { name }
      end

      def self.quest_ids(*ids)
        define_method(:quest_ids) { ids }
      end

      def quest_ids ; [] ; end

      def initialize(user, options = {})
        @user = user
      end

      def start
        res = nil
        QuestRunner.new(@user, quest_ids).run do |quest_ids|
          res = run(quest_ids)
        end
        res
      end

      def run(quest_ids)
        raise 'Not Implemented'
      end

      class QuestRunner
        def initialize(user, request_ids)
          @user = user
          @request_ids = request_ids
          @current_quests = user.quests
          @before_ids = @current_quests.select(&:accept?).map(&:id)
        end

        def run
          @accept_ids = accept
          yield(@accept_ids)
          finish
          restore
        end

        private
        def accept
          start_ids = (@request_ids - @before_ids) & @current_quests.map(&:id)
          stop_count = (start_ids + @before_ids).count - 5
          stop_ids = (@before_ids - @request_ids)[0,stop_count] || []
          stop_ids.each {|id| @user.stop_quest(id) }
          start_ids.each {|id| @user.start_quest(id) }
          @request_ids & @current_quests.map(&:id)
        end

        def finish
          @user.quests.select(&:completable?).each do |quest|
            @user.complete_quest(quest.id)
            p "Complete quest #{quest.id}: #{quest.name}"
          end
        end

        def restore
          quests = @user.quests
          accept_ids = quests.select(&:accept?).map(&:id)
          start_ids = @before_ids & quests.map(&:id) - accept_ids
          stop_count = (start_ids + accept_ids).count - 5
          stop_ids = (accept_ids - @before_ids)[0, stop_count] || []
          stop_ids.each{|id| @user.stop_quest(id) }
          start_ids.each{|id| @user.start_quest(id) }
        end
      end
    end
  end
end

Dir[File.expand_path("../strategies/*", __FILE__)].each { |file| require file }

