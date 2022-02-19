class ApplicationController < ActionController::Base
  before_action :set_current

  def set_current
    if session[:user_id]
      Current.user = User.find_by(id: session[:user_id])
    end
  end

end
