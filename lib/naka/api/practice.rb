module Naka
  module Api
    class Practice < Base
      def all
        response = request '/kcsapi/api_get_member/practice'
        response[:api_data].map {|x| Naka::Models::Practice.new(x) }
      end

      def deck(practice)
        request '/kcsapi/api_req_member/getothersdeck', api_member_id: deck.user_id
      end

      def battle(practice)
        request '/kcsapi/api_req_practice/battle', api_enemy_id: practice.user_id, api_deck_id: 1, api_formation_id: 1
      end

      def midnight(practice)
        request '/kcsapi/api_req_practice/midnight_battle', api_enemy_id: practice.user_id, api_formation_id: 1, api_deck_id: 0
      end

      def result(practice)

      end
    end

    Manager.register :practice, Practice
  end
end
