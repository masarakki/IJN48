require 'spec_helper'

describe Naka::Models::Battle::Move do
  subject { move }
  context :start, '1-2' do
    before do
      stub_request(:post, "http://0.0.0.0/kcsapi/api_req_map/start").
        to_return(status: 200, body: mock_file('api/battle/start/1-2-E.json'))
    end
    let(:move) { mock_user.api.battle.start(1, 2) }
    it { should be_a described_class }

    context :to_east do
      before { stub_request(:any, //).to_return(body: mock_file('api/battle/start/1-2-E.json')) }
      it { should_not be_terminal }
      its(:cell_id) { should == 1 }
      it { should_not be_boss }
      it { should_not be_skippable }
      it { should_not be_midnight }
      it { should_not be_night_to_day }
    end
    context :to_south do
      before { stub_request(:any, //).to_return(body: mock_file('api/battle/start/1-2-S.json')) }
      it { should_not be_terminal }
      its(:cell_id) { should == 2 }
      it { should_not be_boss }
      it { should be_skippable }
      it { should_not be_midnight }
      it { should_not be_night_to_day }
    end
  end

  context :next do
    let(:move) { mock_user.api.battle.next }
    context 'terminal_boss' do
      before { stub_request(:any, //).to_return(body: mock_file('api/battle/next/terminal_boss.json')) }
      it { should be_a described_class }
      it { should be_boss }
      it { should be_terminal }
      it { should_not be_skippable }
      it { should_not be_midnight }
      it { should_not be_night_to_day }
    end

    context 'terminal_not_boss' do
      before { stub_request(:any, //).to_return(body: mock_file('api/battle/next/terminal_not_boss.json')) }
      it { should be_a described_class }
      it { should_not be_boss }
      it { should be_terminal }
      it { should_not be_skippable }
      it { should_not be_midnight }
      it { should_not be_night_to_day }
    end

    context 'skip' do
      before { stub_request(:any, //).to_return(body: mock_file('api/battle/next/skip.json')) }
      it { should be_a described_class }
      it { should_not be_terminal }
      it { should be_skippable }
      it { should_not be_midnight }
      it { should_not be_night_to_day }
    end

    context 'midnight' do
      before { stub_request(:any, //).to_return(body: mock_file('api/battle/next/midnight.json')) }
      it { should be_a described_class }
      it { should_not be_terminal }
      it { should_not be_skippable }
      it { should be_midnight }
      it { should_not be_night_to_day }
    end

    context 'night_to_day' do
      before { stub_request(:any, //).to_return(body: mock_file('api/battle/next/night_to_day.json')) }
      it { should be_a described_class }
      it { should be_terminal }
      it { should be_boss }
      it { should_not be_skippable }
      it { should be_night_to_day }
    end
  end
end
