require 'open-uri'
require 'csv'

class TaxLoader
  class << self
    def call
      insert_rate_records(rate_records)
    end

    def insert_rate_records(attrs_array)
      if attrs_array.length < 39000
        raise StandardError, "Zips are missing: #{attrs_array.length}"
      end
      # make this runnable on free heroku instance
      # since heroku has a 10k rows limit
      if ENV['HEROKU']
        attrs_array = attrs_array.first(9000)
      end
      ZipTaxRate.transaction do
        ZipTaxRate.delete_all
        ZipTaxRate.insert_all(attrs_array)
      end
    end

    def rate_records
      records = []
      zip_code_coordinates = load_zip_code_coordinates
      download_links.each do |link|
        # State,ZipCode,TaxRegionName,StateRate,EstimatedCombinedRate,EstimatedCountyRate,EstimatedCityRate,EstimatedSpecialRate,RiskLevel
        csv = CSV.new(open(link).read, { col_sep: "," }).read
        csv[1..-1].each do |row|
          zip = row[1]
          rate = row[4].to_f
          coords = zip_code_coordinates[zip]
          lat = coords ? coords[0] : nil
          lng = coords ? coords[1] : nil
          records << {
            zip: zip,
            rate: rate,
            latitude: lat,
            longitude: lng
          }
        end
      end
      records
    end

    def load_zip_code_coordinates
      remote_file = open('https://www.aggdata.com/download_sample.php?file=us_postal_codes.csv')
      # Zip Code,Place Name,State,State Abbreviation,County,Latitude,Longitude
      csv = CSV.new(remote_file.read, { col_sep: "," }).read
      zips = {}
      csv[1..-1].each do |row|
        zip = row[0].rjust(5, '0')
        lat = row[5].to_f
        lng = row[6].to_f
        zips[zip] = [lat, lng]
      end
      zips
    end

    def download_links
      states.map { |s| "http://taxrates.csv.s3.amazonaws.com/TAXRATES_ZIP5_#{s}#{date_string}.csv" }
    end

    def states
      %w(AK AL AR AS AZ CA CO CT DC DE FL GA GU HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA PR RI SC SD TN TX UT VA VI VT WA WI WV WY)
    end

    def date_string
      "#{Date.today.year}#{Date.today.month.to_s.rjust(2, '0')}"
    end
  end
end