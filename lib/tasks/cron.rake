task :cron => :environment do
  if Time.now.hour == 0
    Rake::Task['scraper:retrieve'].invoke
  end
  Rake::Task['scraper:google_news'].invoke
end
