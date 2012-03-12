# MaMairie.ca

[MaMairie.ca](http://mamairie.ca/) helps you track and interact with your municipal elected officials. Currently launched in Montreal, QC. We have a number of features planned and data to integrate:

* councillor remuneration and expenses
* electoral results
* meeting attendance
* question period
* ... and much more

## Getting Started

    bundle exec rake db:seed
    bundle exec rake scraper:retrieve
    bundle exec rake fixes:google_news
    bundle exec rake scraper:photos
    bundle exec rake scraper:wikipedia
    bundle exec rake scraper:google_news
    bundle exec rake scraper:twitter
    rspec lib/sanity.rb

# Deployment

    heroku run rake db:seed
    heroku run rake scraper:retrieve
    heroku run rake fixes:google_news
    heroku run rake scraper:photos
    heroku run rake scraper:wikipedia
    heroku run rake scraper:google_news
    heroku run rake scraper:twitter
    rspec lib/sanity.rb

If you'd like to volunteer, please contact [info@opennorth.ca](mailto:info@opennorth.ca).