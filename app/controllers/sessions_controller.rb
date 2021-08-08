class SessionsController < ApplicationController
  def new
    redirect_to current_user if logged_in?
  end

  def create
    user = User.find_by email: params[:sessions][:email].downcase
    remember_value = params[:sessions][:remember_me]
    if user&.authenticate params[:sessions][:password]
      login_activated_user user, remember_value
    else
      flash[:danger] = t "sessions.message.login_failed"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def login user, remember_value
    flash[:sucess] = t "sessions.message.login_success"
    log_in user
    remember_value == "1" ? remember(user) : forget(user)
  end

  def login_activated_user user, remember_value
    if user.activated
      login user, remember_value
      redirect_back_or user
    else
      flash[:warning] = t "message.not_active"
      redirect_to root_url
    end
  end
end
