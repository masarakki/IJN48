# -*- coding: utf-8 -*-
require 'spec_helper'

describe Naka::Models::Master::MapInfo do
  let(:api) { mock_user.api.master.mapinfo }
  context :id, 1 do
    subject { api.find(7) }
    its(:name) { should == '東部オリョール海' }
    its(:area_id) { should == 2 }
    its(:map_id) { should == 3 }
    it { should be_enabled }
    it { should be_cleared }
    it { should_not be_event_boss }
  end

  context '23-4' do
    subject { api.find(112) }
    its(:name) { should == 'アイアンボトムサウンド' }
    its(:area_id) { should == 23 }
    its(:map_id) { should == 4 }
    it { should be_enabled }
    it { should_not be_cleared }
    it { should be_event_boss }
  end
end
