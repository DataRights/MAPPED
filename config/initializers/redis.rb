if ENV["REDISTOGO_URL"] # This is for Heroku only
  uri = ENV["REDISTOGO_URL"]
  REDIS = Redis.new(:url => uri)
end
