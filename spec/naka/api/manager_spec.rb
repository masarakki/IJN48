require 'spec_helper'

describe Naka::Api::Manager do
  describe :register do
    let(:target_class) { Class.new(Naka::Api::Manager) }
    before do
      Naka::Api::Manager.register(:target, target_class)
    end
    subject { Naka::Api::Manager.new(mock_user) }
    it { should be_respond_to :target }
    its(:target) { should be_a target_class }
  end
end
