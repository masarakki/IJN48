require 'spec_helper'

describe Naka::Api do
  describe Naka::Api::Manager do
    it { expect(mock_user.api).to be_a Naka::Api::Manager }
    it { expect(mock_user.api.factory).to be_a Naka::Api::Manager }
    it { expect(mock_user.api.factory.ship).to be_a Naka::Api::Base }
  end
end
