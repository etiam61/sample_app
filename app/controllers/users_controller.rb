class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.all.page(params[:page]).per Settings.page.per
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per Settings.page.per
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".message.check_email"
      redirect_to login_url
    else
      flash[:danger] = t ".message.user_create_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".message.update_success"
      redirect_to @user
    else
      flash[:danger] = t ".message.update_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".message.delete_success"
    else
      flash[:danger] = t ".message.delete_failed"
    end
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def correct_user
    redirect_to root_path unless current_user == @user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.index.not_found"
    redirect_to root_path
  end
end
