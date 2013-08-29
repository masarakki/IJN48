require 'spec_helper'

describe Naka::OldApi::Mission do
  describe :start_mission do
    it 'call api' do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_req_mission/start").with(:body => {"api_deck_id" => "2", "api_mission_id" => "1", "api_token" => mock_user.api_token, "api_verno" => "1"}).to_return(:status => 200, :body =>  mock_file('api/mission/start.json'), :header => {})
      mock_user.start_mission(2, 1)
    end
  end

  describe :mission_result do
    it 'call api' do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_req_mission/result").with(:body => {"api_deck_id" => "2", "api_token" => mock_user.api_token, "api_verno" => "1"}).to_return(:status => 200, :body =>  mock_file('api/mission/result.json'), :header => {})
      mock_user.mission_result(2)
    end
  end
end
