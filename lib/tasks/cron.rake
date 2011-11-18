task :cron => :environment do
  Rake::Task['scraper:retrieve'].invoke
  Rake::Task['scraper:process'].invoke
end
