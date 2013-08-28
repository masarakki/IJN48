require 'spec_helper'

describe Naka::Api::Ships do
  describe :ships do
    before do
      mock_user.stub(:ships_master) { build_list(:ship_master, 500) }
    end
    it 'call api' do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_member/ship2").
        with(:body => {"api_sort_key" => "1", "api_sort_order" => "2", "api_token" => mock_user.api_token, "api_verno" => "1"},
        :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate, sdch',
          'Content-Length'=>'59','Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby', 'Referer' => "http://#{mock_user.api_host}/kcs/mainD2.swf?api_token=#{mock_user.api_token}&api_starttime=#{mock_user.api_at}", 'Origin' => "http://#{mock_user.api_host}", 'Host' => mock_user.api_host}).
        to_return(:status => 200, :body => mock_file('api/ships/response.json'), :headers => {})
      ships = mock_user.ships
      expect(ships.count).to eq 83
      expect(ships.first.master.id).to eq 119
    end
  end

  describe :ships_master do
    before { Naka.redis.del('naka:master:ships') }
    after { Naka.redis.del('naka:master:ships') }

    it 'call api' do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/ship").to_return(:status => 200, :body => mock_file('api/ships/master.json'), :headers => {})
      mock_user.ships_master
    end
    it 'cache result' do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/ship").to_return(:status => 200, :body => mock_file('api/ships/master.json'), :headers => {})
      mock_user.ships_master
      expect(Naka.redis.exists('naka:master:ships')).to be_true
    end
  end
end
