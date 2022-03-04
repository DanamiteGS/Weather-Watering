class ApplicationController < ActionController::Base
  before_action :set_current

  def set_current
    if session[:user_id]
      Current.user = User.find_by(id: session[:user_id])
    end
  end

  def require_user_logged_in!
    redirect_to login_path, alert: "You must be signed in to do that!" if Current.user.nil?
  end

  def require_user_logged_out
    redirect_to root_path if Current.user.present?
  end

end
