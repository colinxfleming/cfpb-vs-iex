# frozen_string_literal: true

class CompanyLookupService
  def self.lookup(company)
    # Start with CFPB because it is way more brittle
    complaint = CFPBService.search_complaints company
    



  end



end
