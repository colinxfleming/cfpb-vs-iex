# frozen_string_literal: true

class CompanyLookupService
  # CFPB_OPTIONS = load_cfpb_companies
  # IEX_OPTIONS = load_iex_companies
  # Is this a good use case for a class variable? WOOF

  NONWORDS = %w(inc the and)

  def self.lookup(company)
    cfpb_name = fuzzy_cfpb_lookup(company)

    match_cfpb_to_iex cfpb_name
    # Do something to narrow down results
  end

  def self.pull_company(company)
    # Start with CFPB because it is way more brittle
    complaint = CFPBService.search_complaints 
  end

  def self.fuzzy_cfpb_lookup(company)
    # Regex match 
    load_cfpb_companies.select { |opt| /#{company}/i =~ opt }
  end

  def self.load_cfpb_companies
    filepath = File.join(Rails.root, 'app', 'datasets', 'cfpb_companies.txt')
    File.read(filepath)
        .split("\n") # ewwww
  end

  def self.load_iex_companies
    filepath = File.join(Rails.root, 'app', 'datasets', 'iex_companies.json')
    JSON.parse File.read(filepath)
  end

  def self.match_cfpb_to_iex(cfpb_name)
    iex_data = load_iex_companies
    core_name = cfpb_name.delete('.,')
                         .split(' ')
                         .reject { |word| NONWORDS.include? word.downcase }


  end



  def self.rough_match(cfpb, iex)
    /#{iex}/i =~ cfpb
  end
end
