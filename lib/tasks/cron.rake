task :cron => :environment do
  Rake::Task['scraper:retrieve'].invoke
  Rake::Task['scraper:twitter'].invoke
  Rake::Task['scraper:google_news'].invoke
end
