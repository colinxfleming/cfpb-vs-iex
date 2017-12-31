# frozen_string_literal: true

class IEXService
  BASE_URL = 'https://api.iextrading.com/1.0'.freeze
  COMPANY_SYMBOLS_ENDPOINT = 'ref-data/symbols'.freeze

  def self.search_stocks(company_name)
    search_url = "#{BASE_URL}/#{stocks_endpoint(company_name)}"

    stock = HTTParty.get search_url
    stock.parsed_response
  end

  def self.stocks_endpoint(company_name)
    # Figure out the symbol from the name, then search by the symbol
    company_symbol = company_symbols.find { |company| company['name'] == company_name }['symbol']
    "stock/#{company_symbol.downcase}/quote"
  end

  def self.company_symbols
    # Calling this every single time is silly, note to self to load it into a JSON CONST maybe
    symbols_url = "#{BASE_URL}/#{COMPANY_SYMBOLS_ENDPOINT}"
    HTTParty.get(symbols_url).parsed_response
  end
end
