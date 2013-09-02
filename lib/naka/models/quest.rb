module Naka
  module Models
    class Quest
      attr_accessor :id, :name, :state
      def self.from_api(response)
        quest = self.new
        response.delete(:api_id)
        response.each_pair do |key, value|
          key = key.to_s.gsub /api_/, ''
          quest.send("#{key}=", value) if quest.respond_to?("#{key}=")
        end
        quest
      end

      def counts
        if @requires && @currents
          @requires.zip(@currents).map do |require, current|
            "#{current} / #{require}"
          end
        else
          nil
        end
      end

      def to_json(options = {})
        {id: id, name: name, state: state, counts: counts}.to_json
      end

      def completable? ; state == 3 ; end
      def no=(val) ; @id = val ; end
      def title=(val) ; @name = val ; end
      def clear_count=(val) ; @requires = val == -1 ? nil : val ; end
      def now_count=(val) ; @currents = val == -1 ? nil : val ; end
    end
  end
end
