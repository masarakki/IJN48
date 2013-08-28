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

      def completable? ; state == 3 ; end
      def no=(val) ; @id = val ; end
      def title=(val) ; @name = val ; end
    end
  end
end
