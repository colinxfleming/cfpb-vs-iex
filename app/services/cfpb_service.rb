# frozen_string_literal: true

class CFPBService
  # Docs: https://dev.socrata.com/foundry/data.consumerfinance.gov/jhzv-w97w
  DATASET_IDENTIFIER = 'jhzv-w97w'.freeze
  BASE_URL = 'https://data.consumerfinance.gov/resource'.freeze
  DATASET_URL = "#{BASE_URL}/#{DATASET_IDENTIFIER}.json".freeze

  def self.search_complaints(company_name)
    # Socrata has a SQL-ish API. Nice of 'em.
    # Not so nice: Case sensitive :(
    filter = "$where=company like '%#{company_name}%'"
    limit = '$limit=5'
    search_url = URI.escape("#{DATASET_URL}?#{filter}&#{limit}")
    complaints = HTTParty.get search_url

    {
      complaints: complaints.parsed_response,
      comment: find_comment(complaints)
    }
  end

  def self.find_comment(complaint_json)
    complaint_json.select { |complaint| complaint['complaint_what_happened'].present? }
                  .sample['complaint_what_happened']
  end

  def self.company_list
    HTTParty.get(DATASET_URL)
            .parsed_response
            .map { |x| { name: x['company'] } }
            .uniq
  end
end
