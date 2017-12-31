require 'test_helper'

class CFBPServiceTest < ActiveSupport::TestCase
  describe 'cfpb service' do
    it 'should respond to search complaints' do
      assert CFPBService.respond_to? :search_complaints
    end
  end
end
