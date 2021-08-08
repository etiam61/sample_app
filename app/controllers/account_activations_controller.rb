class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      activate_user user
      redirect_to user
    else
      flash[:danger] = t "message.active.fail"
      redirect_to root_url
    end
  end

  private
  def activate_user user
    user.activate
    log_in user
    flash[:success] = t "message.activate.success"
  end
end
