require 'csv'

# Dir.glob("#{Rails.root}/app/services/*.rb").each { |f| require f }

desc 'Refresh CFPB list of companies'
task :refresh_cfpb => :environment do
  all_companies = CFPBService.company_list
  filepath = File.join(Rails.root, 'app', 'datasets', 'cfpb_companies.txt')

  File.open(filepath, 'w') do |f|
    all_companies.each do |company|
      f.write "#{company}\n"
    end
  end
end
