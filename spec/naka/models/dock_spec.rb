require 'spec_helper'

describe Naka::Models::Dock do
  before { Time.stub(:now) { Time.at(1377117600) } }
  describe :used_dock do
    subject { Naka::Models::Dock.new(MultiJson.load(mock_file('models/dock/used.json'))) }
    its(:id) { should == 1 }
    its(:member_id) { should == 32377 }
    its(:ship_id) { should == 1233 }
    its(:repairs_at) { should == Time.parse("2013-08-22 05:41:18 +0900") }
    its(:repairs_in) { should == 78 }
    it { should be_used }
    it { should_not be_blank }
  end

  describe :blank_dock do
    subject { Naka::Models::Dock.new(MultiJson.load(mock_file('models/dock/blank.json'))) }
    its(:id) { should == 4 }
    its(:member_id) { should == 32377 }
    its(:ship_id) { should be_nil }
    its(:repairs_at) { should be_nil }
    its(:repairs_in) { should be_nil }
    it { should_not be_used }
    it { should be_blank }
  end

  describe :factoreis do
    describe :blank do
      subject { build(:dock, :blank) }
      it { should be_blank }
    end
    describe :short do
      subject { build(:dock, :short) }
      it { should be_used }
      its(:repairs_in) { should == 10 * 60 }
    end
    describe :long do
      subject { build(:dock, :long) }
      it { should be_used }
      its(:repairs_in) { should == 12 * 60 * 60 }
    end
  end
end
