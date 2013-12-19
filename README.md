# MaMairie.ca

[![Dependency Status](https://gemnasium.com/opennorth/mamairie.ca.png)](https://gemnasium.com/opennorth/mamairie.ca)

[MaMairie.ca](http://mamairie.ca/) helps you track and interact with city hall.

## Getting Started

    bundle exec rake db:seed
    bundle exec rake scraper:retrieve
    bundle exec rake fixes:google_news
    bundle exec rake scraper:photos
    bundle exec rake scraper:wikipedia
    bundle exec rake scraper:google_news
    rspec lib/sanity.rb

## Deployment

    heroku run rake db:seed
    heroku run rake scraper:retrieve
    heroku run rake fixes:google_news
    heroku run rake scraper:photos
    heroku run rake scraper:wikipedia
    heroku run rake scraper:google_news
    rspec lib/sanity.rb

If you'd like to volunteer, please contact [info@opennorth.ca](mailto:info@opennorth.ca).

## Bugs? Questions?

This app's main repository is on GitHub: [http://github.com/opennorth/mamairie.ca](http://github.com/opennorth/mamairie.ca), where your contributions, forks, bug reports, feature requests, and feedback are greatly welcomed.

Copyright (c) 2012 Open North Inc., released under the MIT license
