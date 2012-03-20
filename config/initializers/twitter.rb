# @note OAuth calls raise limit to 350 per hour: https://dev.twitter.com/docs/rate-limiting
# @note Apigee has much higher rate limits (e.g. 20 000).
Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end
if ENV['APIGEE_TWITTER_API_ENDPOINT']
  Twitter.gateway = ENV['APIGEE_TWITTER_API_ENDPOINT']
end
