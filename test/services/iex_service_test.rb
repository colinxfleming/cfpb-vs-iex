require 'test_helper'

class IEXServiceTest < ActiveSupport::TestCase
  describe 'cfpb service' do
    it 'should respond to search complaints' do
      assert IEXService.respond_to? :search_stocks
    end
  end
end
