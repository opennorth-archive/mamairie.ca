namespace :maintenance do
  desc 'Output translations as CSV'
  task :translations => :environment do
    require 'csv'
    require 'iconv'

    def walk(csv, hash, prefix = nil)
      hash.each do |key,value|
        full = [prefix, key].compact.join('.')
        if Hash === value
          walk csv, value, full
        else
          csv << [full, value]
        end
      end
    end

    hash = YAML.load_file(File.join(Rails.root, 'config', 'locales', 'fr.yml'))['fr'].delete_if do |key,_|
      %w(date time datetime number support helpers errors attributes activerecord mongo_mapper).include? key
    end

    string = CSV.generate(:col_sep => "\t") do |csv|
      walk csv, hash
    end

    File.open(File.join(Rails.root, 'translations.csv'), 'wb') do |f|
      f.write Iconv.conv('utf-16le', 'utf-8', "\xEF\xBB\xBF") + Iconv.conv('utf-16le', 'utf-8', string)
    end
  end
end
