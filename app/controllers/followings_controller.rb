class FollowingsController < ApplicationController
  before_action :logged_in_user, :find_user

  def index
    @title = t "follow.following"
    @users = @user.following.page(params[:page]).per Settings.page.per
    render "users/show_follow"
  end
end
