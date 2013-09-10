require 'spec_helper'

describe Naka::Api::Master::Map do
  def mock_map(map, area)
    stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/mapcell").
      with(body: {api_maparea_id: map.to_s, api_mapinfo_no: area.to_s,
        api_verno: "1", api_token: mock_user.api_token}).
      to_return(body: mock_file("api/master/map/#{map}-#{area}.json"))
  end

  describe '4-1' do
    before { mock_map(4, 1) }
    subject { mock_user.api.master.map(4, 1) }
    it { should be_a Naka::Models::Master::Map }
    its(:map_id) { should == 4 }
    its(:area_id) { should == 1 }
  end
end
