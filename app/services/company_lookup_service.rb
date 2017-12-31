# frozen_string_literal: true

class CompanyLookupService
  # CFPB_OPTIONS = load_cfpb_companies
  # IEX_OPTIONS = load_iex_companies
  # TODO Port this to run as an instance.

  NONWORDS = %w(inc the and)

  # Frontend access point. Look up general thing and confirm existence
  def self.lookup(company)
    cfpb_name = fuzzy_cfpb_lookup(company).first

    iex_name = match_cfpb_to_iex cfpb_name
    { cfpb: cfpb_name['name'], iex: iex_name['name'] }
  end

  # Frontend access point. Pull down and return both
  # def self.pull_company(cfpb_company, iex_company)
  #   # Start with CFPB because it is way more brittle
  #   complaint = CFPBService.search_complaints cfpb_company
  # end

  def self.fuzzy_cfpb_lookup(company)
    load_cfpb_companies.select { |opt| /#{company}/i =~ opt['name'] }
  end

  def self.match_cfpb_to_iex(cfpb_name)
    iex_data = load_iex_companies
    core_name = clean cfpb_name['name']

    exact_match = iex_data.find { |x| clean(x['name']) == core_name }

    if exact_match
      exact_match
    else
      # Sloppy rough matcher, but works for a proof of concept.
      iex_data.find { |x| clean(x['name'])[0] == core_name[0] }
    end
  end

  def self.clean(company_name)
    company_name.delete(',.')
                .split(' ')
                .reject { |word| NONWORDS.include? word.downcase }
                .map(&:downcase)
  end

  def self.rough_match(cfpb, iex)
    /#{iex}/i =~ cfpb
  end

  def self.load_cfpb_companies
    filepath = File.join(Rails.root, 'app', 'datasets', 'cfpb_companies.json')
    JSON.parse File.read(filepath)
  end

  def self.load_iex_companies
    filepath = File.join(Rails.root, 'app', 'datasets', 'iex_companies.json')
    JSON.parse File.read(filepath)
  end
end
