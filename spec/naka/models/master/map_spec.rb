require 'spec_helper'

describe Naka::Models::Master::Map do
  def stub_map(map, area)
    stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_master/mapcell").
      to_return(status: 200, body: mock_file("api/master/map/#{map}-#{area}.json"))
  end

  context '1-3' do
    before { stub_map(1, 3) }
    let(:map) { mock_user.api.master.map(1, 3) }
    subject { map }
    it { should be_a Naka::Models::Master::Map }
    its(:map_id) { should == 1 }
    its(:area_id) { should == 3 }

    context :find, 0 do
      subject { map.find(0) }
      it { should be_start }
    end

    context :find, 1 do
      subject { map.find(1) }
      it { should be_battle }
      it { should_not be_boss }
    end

    context :find, 2 do
      subject { map.find(2) }
      it { should be_trap }
    end

    context :find, 3 do
      subject { map.find(3) }
      it { should be_item }
    end

    context :find, 4 do
      subject { map.find(4) }
      it { should be_item }
    end

    context :find, 7 do
      subject { map.find(7) }
      it { should be_battle }
      it { should be_boss }
    end
  end

  1.upto 4 do |i|
    1.upto 4 do |j|
      context "#{i}-#{j}" do
        before { stub_map(i, j) }
        let(:map) { mock_user.api.master.map(i, i) }
        subject { map }
        it { should be_a Naka::Models::Master::Map }
      end
    end
  end

  context "4-1" do
    before { stub_map(4, 1) }
    let(:map) { mock_user.api.master.map(4, 1) }
    subject { map }
    it { should be_a Naka::Models::Master::Map }

    context :find, 6 do
      subject { map.find(6) }
      it { should be_battle }
    end
  end
end
