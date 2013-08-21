require 'spec_helper'

describe Naka::Api::Ships do
  it 'call api' do
    stub_request(:post, "http://#{user.api_host}/kcsapi/api_get_member/ship2").
      with(:body => {"api_sort_key" => "1", "api_sort_order" => "2", "api_token" => user.api_token.to_s, "api_verno" => "1"},
      :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate, sdch',
        'Content-Length'=>'59','Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby', 'Referer' => 'http://0.0.0.0/kcs/mainD2.swf?api_token=token&api_starttime=0', 'Origin' => "http://#{user.api_host}", 'Host' => user.api_host}).
      to_return(:status => 200, :body => mock_file('api/ships/response.json'), :headers => {})
    deck = user.ships
    expect(deck[:ships].count).to eq 83
    expect(deck[:groups].count).to eq 4
  end
end
