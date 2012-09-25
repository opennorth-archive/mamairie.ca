# The default host used in mailer views. The public mailer sets the host to the
# questionnaire's domain. The admin mailer sets the host to the localized app
# domain, set in the locale files.
#
# @see http://guides.rubyonrails.org/action_mailer_basics.html#generating-urls-in-action-mailer-views
#
# Used in:
#   config/environments/production.rb
ENV['ACTION_MAILER_HOST'] = 'REPLACE_ME'

# In production, this app stores uploads on Amazon S3. Sign up to get your
# access key ID and secret access key.
#
# @see http://aws.amazon.com/s3/
#
# Used in:
#   config/initializers/carrierwave.rb
ENV['AWS_ACCESS_KEY_ID'] = 'REPLACE_ME'
ENV['AWS_SECRET_ACCESS_KEY'] = 'REPLACE_ME'

# Your bucket name. If your top-level domain is example.com, name your budget
# public.example.com and create a CNAME DNS record to point to the bucket.
#
# @see http://docs.amazonwebservices.com/AmazonS3/latest/dev/VirtualHosting.html#VirtualHostingCustomURLs
#
# Used in:
#   config/initializers/carrierwave.rb
ENV['AWS_DIRECTORY'] = 'REPLACE_ME'

# Uncomment the following line to log exceptions to Airbrake when running a
# production environment locally. Run "heroku config:get AIRBRAKE_API_KEY" to
# get its value from Heroku.
#
# Heroku sets this in production.
#
# Used in:
#   config/initializers/airbrake.rb
# ENV['AIRBRAKE_API_KEY'] = 'REPLACE_ME'

# Required to run a production environment locally.
#
# Heroku sets this in production.
#
# Used in:
#   config/mongoid.yml
ENV['MONGOLAB_URI'] = 'mongodb://127.0.0.1:27017/mamairie_development'
