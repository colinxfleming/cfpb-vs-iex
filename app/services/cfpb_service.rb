# frozen_string_literal: true

class CFPBService
  DATASET_IDENTIFIER = 'jhzv-w97w'
  BASE_URL = 'https://data.consumerfinance.gov/resource'
  DATASET_URL = "#{BASE_URL}/#{DATASET_IDENTIFIER}.json"

  def self.search_complaints(company_name)
    # Socrata has a SQL-ish API. Nice of 'em
    filter = "$where=company like '%#{company_name}%'"
    search_url = URI.escape("#{DATASET_URL}?#{filter}")
    complaints = HTTParty.get search_url
    complaints
  end
end
