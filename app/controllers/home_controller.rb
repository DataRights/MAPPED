class HomeController < ApplicationController
  def index
    if current_user
      return redirect_to campaigns_path
    end
    @requests_sent = AccessRequest.cached_count
    @responses = 0 # ??
    @participants = User.cached_count
    @organizations = Organization.cached_count
  end
end
