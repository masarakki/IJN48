require 'spec_helper'

describe Naka::Models::Fleet do
  describe :from_api do
    context :fist_fleet do
      subject { Naka::Models::Fleet.from_api(MultiJson.load(mock_file('models/fleet/1st.json'))) }
      its(:id) { should == 1 }
      it { should_not be_missionable }
      its(:ship_ids) { should == [163, 82, 283, 76, 229, 75] }
    end
    context :in_mission do
      subject { Naka::Models::Fleet.from_api(MultiJson.load(mock_file('models/fleet/missioning.json'))) }
      before { subject.mission.stub(:finished?) { false } }
      its(:id) { should == 2 }
      its(:mission) { should be_a Naka::Models::Fleet::Mission }
      its("mission.id") { should == 2 }
      its("mission.finish_at") { should be_a Time }
      it { should_not be_missionable }
      its(:ship_ids) { should == [418, 31, 228, 57, nil, nil] }
    end
    context :not_mission do
      subject { Naka::Models::Fleet.from_api(MultiJson.load(mock_file('models/fleet/not_missioning.json'))) }
      its(:id) { should == 4 }
      its(:mission) { should be_nil }
      it { should be_missionable }
      its(:ship_ids) { should == [275, 279, 68, 16, nil, nil] }
    end
  end
end
