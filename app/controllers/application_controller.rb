class ApplicationController < ActionController::Base
  private

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def organization_name
    @organization_name ? Organization.find_by_id(current_user.organization_id).name : nil
  end
  helper_method :current_user, :organization_name
end
