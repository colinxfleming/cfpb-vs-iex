require 'csv'

# Dir.glob("#{Rails.root}/app/services/*.rb").each { |f| require f }

namespace :refresh do
  desc 'Refresh CFPB list of companies'
  task :cfpb => :environment do
    all_companies = CFPBService.company_list
    filepath = File.join(Rails.root, 'app', 'datasets', 'cfpb_companies.txt')

    File.open(filepath, 'w') do |f|
      all_companies.each do |company|
        f.write "#{company}\n"
      end
    end
  end

  desc 'Refresh IEX list of companies'
  task :iex => :environment do
    all_companies = IEXService.company_list
    filepath = File.join(Rails.root, 'app', 'datasets', 'iex_companies.json')

    File.open(filepath, 'w') do |f|
      f.write all_companies.to_json
    end
  end
end
