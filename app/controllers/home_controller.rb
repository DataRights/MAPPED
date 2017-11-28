class HomeController < ApplicationController
  def index
    @requests_sent = AccessRequest.cached_count
    @responses = 0 # ??
    @participants = User.cached_count
    @organizations = Organization.cached_count
  end
end
