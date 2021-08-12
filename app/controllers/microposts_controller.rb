class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "microposts.message.create_success"
    else
      @feed_items = current_user.feed.page params[:page]
      flash[:danger] = t "microposts.message.create_fail"
    end
    redirect_to root_path
  end

  def destroy
    @micropost = current_user.microposts.find_by id: params[:id]
    if @micropost&.destroy
      flash[:success] = t "microposts.message.delete_success"
    else
      flash[:danger] = t "microposts.message.delete_fail"
    end
    redirect_to request.referer || root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end
end
