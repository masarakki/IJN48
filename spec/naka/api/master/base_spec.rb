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
    it { expect(subject.send(:keyname)).to eq 'ijn48:test:master:tests' }
  end

  describe :parser do
    it { expect(Naka::Api::Master::Map.parser).to eq Naka::Models::Master::Map }
  end

  describe :build do
    it {
      p mock_user.api.master.ship
      p mock_user.api.master.ship.find(14)
    }
  end

  context :requires_args do
    let(:target_class) do
      Class.new(Naka::Api::Master::Base) do
        cache 'tests'
        endpoint 'test'
        args :map_id, :area_id
      end
    end
    it 'args to required_args' do
      expect(target_class.required_args).to eq [:map_id, :area_id]
    end
    it 'not change other class' do
      expect(Naka::Api::Master::Ship.required_args).to eq []
    end

    describe :keyname do
      it { expect(instance.send(:keyname, 1, 2)).to eq "ijn48:test:master:tests:1:2" }
    end

    describe :api_response do
      it 'should call api' do
        instance.should_receive(:request).with "/kcsapi/api_get_master/test", api_map_id: 1, api_area_id: 2
        instance.send(:api_response, 1, 2)
      end
      it 'raise unless args enough' do
        expect{ instance.send(:api_response, 1) }.to raise_error(ArgumentError)
      end
    end
  end
end
