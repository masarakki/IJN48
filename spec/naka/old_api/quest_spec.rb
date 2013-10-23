# -*- coding: utf-8 -*-
require 'spec_helper'

describe Naka::OldApi::Quest do
  describe :quests do
    it 'call api' do
      (1..2).each do |page|
        stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_member/questlist").
          with(:body => {"api_page_no"=>page.to_s, "api_token"=>mock_user.api_token, "api_verno"=>"1"}).
          to_return(:status => 200, :body => mock_file("api/quest/quests_#{page}.json"))
      end
      quests = mock_user.quests
      expect(quests.count).to eq 6

      quest = quests.first
      expect(quest.name).to eq "潜水艦隊を編成せよ！"
      expect(quest.id).to eq 125
    end
  end
end
