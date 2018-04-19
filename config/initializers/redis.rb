if ENV["REDISTOGO_URL"]
  uri = ENV["REDISTOGO_URL"]
  REDIS = Redis.new(:url => uri)
end
