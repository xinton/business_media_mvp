class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:organization], params[:email], params[:password])
    if user
      session[:user_id] = user.id
      # TODO actual organization on session[]
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
