require 'spec_helper'

describe Naka::Api::Master::Area do
  let(:area) { mock_user.api.master.area }
  describe :ids do
    it { expect(area.map(&:id)).to eq [1, 2, 3, 4, 5, 23, 24] }
  end
end
