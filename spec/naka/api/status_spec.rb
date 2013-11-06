require 'spec_helper'

describe Naka::Api::Status do
  let(:api) { mock_user.api.status }
  describe :materials do
    subject { api.materials }

    its(:fuel) { should == 1706 }
    its(:bullet) { should == 64433 }
    its(:steel) { should == 12948 }
    its(:bauxite) { should == 36164 }
    its(:repair) { should == 503 }
    its(:ship) { should == 264 }
    its(:creator) { should == 945 }
  end
end
