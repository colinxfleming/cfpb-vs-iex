class MatchersController < ApplicationController
  def index; end

  def cfpb_lookup
    api_response = CompanyLookupService.new.lookup params[:company_name]
    puts params
    puts response
    @company_match = process_cfpb_lookup_response api_response
    respond_to { |format| format.js }
  end

  def exact_lookup
    @api_responses = CompanyLookupService.new.pull_company params[:cfpb_name],
                                                           params[:iex_name]
    
    puts @api_responses
    respond_to { |format| format.js }
  end

  private

  def process_cfpb_lookup_response(api_response)
    if api_response[:cfpb].blank?
      api_response.merge error: 'No company in the CFPB with a name like that.'
    elsif api_response[:iex].blank?
      api_response.merge error: 'We found a CFPB complaint, but could not ' \
                                'find a publicly traded stock associated with' \
                                ' that company.'
    else
      api_response
    end
  end
end
