module Naka
  module Api
    module Quest
      def quests
        page = 1
        result = []
        loop {
          response = api.post "/kcsapi/api_get_member/questlist", api_page_no: page
          pages = response[:api_data][:api_page_count]
          executes = response[:api_data][:api_exec_list].select{|x| x.instance_of? Hash}
          response[:api_data][:api_list].select{|x| x.instance_of? Hash}.map do |quest|
            apply = executes.any? {|exec| exec[:api_no] == quest[:api_no]}
            result << Naka::Models::Quest.from_api(quest.merge(api_apply: apply))
          end
          break if page == pages
          page += 1
        }
        result
      end
    end
  end
end
