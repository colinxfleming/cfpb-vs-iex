# frozen_string_literal: true

class CompanyLookupService
  NONWORDS = %w(inc the and)

  attr_reader :cfpb_data, :iex_data
  attr_accessor :cfpb_name, :iex_name

  def initialize
    @cfpb_data = load_cfpb_companies!
    @iex_data = load_iex_companies!
  end

  # Frontend access point. Look up general thing and confirm existence
  def lookup(company)
    @cfpb_name = fuzzy_cfpb_lookup(company).first

    iex_name = match_cfpb_to_iex cfpb_name
    { cfpb: cfpb_name['name'], iex: iex_name['name'] }
  end

  # Frontend access point. Pull down and return both
  def pull_company(cfpb, iex)
    # Start with CFPB because it is way more brittle
    complaint = CFPBService.search_complaints cfpb
    stock = IEXService.search_stocks iex

    {
      cfpb_complaint_count: complaint[:complaint_count],
      cfpb_random_complaint: complaint[:comment],
      iex: stock
    }
  end

  private

  def fuzzy_cfpb_lookup(company)
    @cfpb_data.select { |opt| /#{company}/i =~ opt['name'] }
  end

  def match_cfpb_to_iex(cfpb_name)
    core_name = clean cfpb_name['name']

    exact_match = @iex_data.find { |x| clean(x['name']) == core_name }

    if exact_match
      exact_match
    else
      # Sloppy rough matcher, but works for a proof of concept.
      # Should do some word bucketing here instead.
      # Note an
      iex_data.find { |x| clean(x['name'])[0] == core_name[0] }
    end
  end

  def clean(company_name)
    company_name.delete(',.')
                .split(' ')
                .reject { |word| NONWORDS.include? word.downcase }
                .map(&:downcase)
  end

  def load_cfpb_companies!
    load_dataset 'cfpb_companies'
  end

  def load_iex_companies!
    load_dataset 'iex_companies'
  end

  def load_dataset(dataset)
    filepath = File.join(Rails.root, 'app', 'datasets', "#{dataset}.json")
    JSON.parse File.read(filepath)
  end
end
