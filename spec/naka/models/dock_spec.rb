require 'spec_helper'

describe Naka::Models::Dock do
  describe :used_dock do
    subject { Naka::Models::Dock.new(MultiJson.load(mock_file('models/dock/used.json'))) }
    its(:id) { should == 1 }
    its(:member_id) { should == 32377 }
    its(:ship_id) { should == 1233 }
    its(:repairs_at) { should == Time.parse("2013-08-22 05:41:18") }
    it { should be_used }
    it { should_not be_blank }
  end

  describe :blank_dock do
    subject { Naka::Models::Dock.new(MultiJson.load(mock_file('models/dock/blank.json'))) }
    its(:id) { should == 4 }
    its(:member_id) { should == 32377 }
    its(:ship_id) { should be_nil }
    its(:repairs_at) { should be_nil }
    it { should_not be_used }
    it { should be_blank }
  end
end
