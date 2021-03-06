class PasswordResetsController < ApplicationController
  before_action :load_user, :check_expiration, only: %i(edit update)
  before_action :valid_user, only: %i(edit)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".message.send_email"
      redirect_to root_url
    else
      flash[:danger] = t "password_resets.message.fail"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      flash[:danger] = t "password_resets.message.password_blank"
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "password_resets.message.success"
      redirect_to @user
    else
      flash[:danger] = t "password_resets.message.fail"
      render :edit
    end
  end

  private
  def load_user
    @user = User.find_by email: params[:email].downcase
    return if @user&.activated

    redirect_root_error
  end

  def valid_user
    return if @user.authenticated? :reset, params[:id]

    redirect_root_error
  end

  def redirect_root_error
    flash[:danger] = t "password_resets.message.fail"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_resets.message.expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit User::PASSWORD_RESETS_ATTRIBUTES
  end
end
