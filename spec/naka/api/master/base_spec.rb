require 'spec_helper'

describe Naka::Api::Master::Base do
  let(:target_class) do
    Class.new(Naka::Api::Master::Base) do
      cache 'tests'
      endpoint 'test'
    end
  end

  let(:instance) { target_class.new(mock_user) }
  subject { instance }
  describe :keyname do
    it { expect(subject.send(:keyname)).to eq 'ijn48:naka:master:tests' }
  end
  describe :fetch_all do
    it 'should call api' do
      instance.should_receive(:request).with "/kcsapi/api_get_master/test"
      instance.send(:fetch_all)
    end
  end
end
