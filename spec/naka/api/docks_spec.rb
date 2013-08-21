require 'spec_helper'

describe Naka::Api::Docks do
  it 'call api' do
    stub_request(:post, "http://#{user.api_host}/kcsapi/api_get_member/ndock").
      with(:body => {"api_token" => user.api_token.to_s, "api_verno" => "1"},
      :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate, sdch',
        'Content-Length'=>'27','Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby', 'Referer' => 'http://0.0.0.0/kcs/mainD2.swf?api_token=token&api_starttime=0', 'Origin' => "http://#{user.api_host}", 'Host' => user.api_host}).
      to_return(:status => 200, :body => mock_file('api/docks/response.json'), :headers => {})
    docks = user.docks
    expect(docks.count).to eq 4
  end
end
