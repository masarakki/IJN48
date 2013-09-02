require 'spec_helper'

describe Naka::Api::Status do
  let(:api) { mock_user.api.status }
  describe :materials do
    before do
      stub_request(:post, "http://#{mock_user.api_host}/kcsapi/api_get_member/material").to_return(
        :status => 200, :body => mock_file('api/materials/response.json'))
    end
    subject { api.materials }

    its(:fuel) { should == 11894 }
    its(:bullet) { should == 21688 }
    its(:iron) { should == 14642 }
    its(:bauxite) { should == 25102 }
  end
end
