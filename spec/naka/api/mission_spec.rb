require 'spec_helper'

describe Naka::Api::Mission do
  it 'call api' do
    stub_request(:post, "http://0.0.0.0/kcsapi/api_req_mission/start").with(:body => {"api_deck_id" => "2", "api_mission_id" => "1", "api_token" => "token", "api_verno" => "1"}).to_return(:status => 200, :body =>  mock_file('api/mission/start.json'), :header => {})
    user.start_mission(2, 1)
  end
end
