class MatchersController < ApplicationController
  def index; end

  def cfpb_lookup
    api_response = CompanyLookupService.new.lookup params[:company_name]
    @company_match = process_cfpb_lookup_response api_response

    respond_to { |format| format.js }
  end

  def exact_lookup
    api_responses = CompanyLookupService.new.pull_company params[:cfpb_name],
                                                          params[:iex_name]
    @api_responses = process_exact_lookup_response api_responses

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

  def process_exact_lookup_response(api_responses)
    puts api_responses
    if api_responses[:iex]['companyName'].blank? || api_responses[:cfpb_random_complaint].blank?
      api_responses.merge error: 'ERROR'
    else
      api_responses
    end
  end
end
