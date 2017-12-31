# frozen_string_literal: true

class CompanyLookupService
  COMPANY_OPTIONS = load_cfpb_companies

  def self.lookup(company)
    cfpb_name = fuzzy_cfpb_lookup(company)
    # Do something to narrow down results
  end

  def self.pull_company(company)
    # Start with CFPB because it is way more brittle
    complaint = CFPBService.search_complaints 
  end

  def self.fuzzy_cfpb_lookup(company)
    # Regex match 
    COMPANY_OPTIONS.select { |opt| /#{company}/i =~ opt }
  end

  def self.load_cfpb_companies
    filepath = File.join(Rails.root, 'app', 'datasets', 'cfpb_companies.txt')
    File.read(filepath)
        .split("\n") # ewwww
  end

  # def self.load_
end
