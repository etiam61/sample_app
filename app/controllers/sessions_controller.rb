class SessionsController < ApplicationController
  def new
    redirect_to users_path(current_user) if logged_in?
  end

  def create
    user = User.find_by email: params[:sessions][:email].downcase
    if user &.authenticate params[:sessions][:password]
      log_in user
      redirect_to user
    else
      flash[:danger] = t "sessions.message.login_failed"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
