class HomeController < ApplicationController
  def index
    @requests_sent = AccessRequest.count
    @responses = 0 # ??
    @participants = User.count
    @organizations = Organization.count
  end
end
