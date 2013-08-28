# -*- coding: utf-8 -*-
require 'spec_helper'

describe Naka::Api::Quest do
  describe :quests do
    it 'call api' do
      (1..3).each do |page|
        stub_request(:post, "http://0.0.0.0/kcsapi/api_get_member/questlist").
          with(:body => {"api_page_no"=> page.to_s, "api_token"=>"token", "api_verno"=>"1"}).
          to_return(:status => 200, :body => mock_file("api/quest/quests_#{page}.json"))
      end
      quests = user.quests
      expect(quests.count).to eq 15

      quest = quests.first
      expect(quest.name).to eq "「第五航空戦隊」を編成せよ！"
      expect(quest.id).to eq 123
    end
  end
end
