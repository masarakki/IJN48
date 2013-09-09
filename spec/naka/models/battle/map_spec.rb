require 'spec_helper'

describe Naka::Models::Battle::Map do
  context '1-2' do
    before do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/mapcell").
        to_return(status: 200, body: mock_file('api/battle/map/1-2.json'))
    end

    let(:map) { mock_user.api.battle.map(1, 2) }
    subject { map }
    it { should be_a Naka::Models::Battle::Map }
    its(:map_id) { should == 1 }
    its(:area_id) { should == 2 }

    context :find, 0 do
      subject { map.find(0) }
      it { should be_a Naka::Models::Battle::Map::Cell }
      it { should be_start }
    end

    context :find, 1 do
      subject { map.find(1) }
      it { should be_battle }
      it { should_not be_boss }
    end

    context :find, 2 do
      subject { map.find(2) }
      it { should be_item }
    end

    context :find, 3 do
      subject { map.find(3) }
      it { should be_battle }
      it { should be_boss }
    end

    context :find, 4 do
      subject { map.find(4) }
      it { should be_battle }
      it { should_not be_boss }
    end
  end
end
