namespace :tax_rates do
  desc "Loads tax rates"
  task load_tax_rates: :environment do
    TaxLoader.call
  end
end
