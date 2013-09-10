require 'spec_helper'

describe Naka::Api::Manager do
  describe :register do
    context :not_direct do
      let(:target_class) { Class.new(Naka::Api::Manager) }
      before { Naka::Api::Manager.register(:target, target_class) }
      subject { Naka::Api::Manager.new(mock_user) }
      it { should be_respond_to :target }
      its(:target) { should be_a target_class }
    end

    context :direct do
      let(:target_class) do
        Class.new(Naka::Api::Manager) do
          def all(a, b) ; {:a => a, :b => b} ; end
        end
      end
      before { Naka::Api::Manager.register :target, target_class, true }
      subject { Naka::Api::Manager.new(mock_user) }
      it { should be_respond_to :target }
      it { expect(subject.target(1, 2)).to eq({:a => 1, :b => 2}) }
    end
  end

end
