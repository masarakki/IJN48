require 'spec_helper'

describe Naka::Strategies::Base do
  describe :quest_ids do
    subject { klass.new(mock_user) }
    describe :noting do
      let(:klass) { Class.new(Naka::Strategies::Base) }
      its(:quest_ids) { should == [] }
    end
    describe :with_id do
      let(:klass) {
        Class.new(Naka::Strategies::Base) do
          quest_ids 1
        end
      }
      its(:quest_ids) { should == [1] }
    end
    describe :with_ids do
      let(:klass) {
        Class.new(Naka::Strategies::Base) do
          quest_ids 1, 2, 3
        end
      }
      its(:quest_ids) { should == [1, 2, 3] }
    end
  end
end

describe Naka::Strategies::Base::QuestRunner do
  let(:runner) { Naka::Strategies::Base::QuestRunner.new(mock_user, [1, 2, 3, 4, 5]) }
  before do
    mock_user.stub(:quests) { [
        double(:id => 1, :accept? => false),
        double(:id => 2, :accept? => true),
        double(:id => 3, :accept? => false),
        double(:id => 4, :accept? => false),
        double(:id => 6, :accept? => true),
        double(:id => 7, :accept? => true),
        double(:id => 8, :accept? => true)
      ] }
  end
  describe :@before_ids do
    it { expect(runner.instance_variable_get(:@before_ids)).to eq [2, 6, 7, 8] }
  end

  describe :accept do
    it 'chancel and start quests' do
      [6, 7].each {|id| mock_user.should_receive(:stop_quest).with(id) }
      [1, 3, 4].each {|id| mock_user.should_receive(:start_quest).with(id) }
      runner.send(:accept)
    end
    it 'return accepting ids' do
      mock_user.stub(:stop_quest => true, :start_quest => true)
      expect(runner.send(:accept)).to eq [1, 2, 3, 4]
    end
    it '@quest_changed should be true' do
      mock_user.stub(:stop_quest => true, :start_quest => true)
      runner.send(:accept)
      expect(runner.instance_variable_get(:@quest_changed)).to be_true
    end
  end
  describe :restore do
    it 'chancel and start quests' do
      runner.instance_variable_set(:@before_ids, [1, 2, 3, 11])
      runner.instance_variable_set(:@quest_changed, true)
      [6].each {|id| mock_user.should_receive(:stop_quest).with(id) }
      [1, 3].each {|id| mock_user.should_receive(:start_quest).with(id) }
      runner.send(:restore)
    end
  end
end
