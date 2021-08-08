module UsersHelper
  def gravatar_for user, size = Settings.image.avatar_size
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = t "users.helper.gravatar_link", gravatar_id: gravatar_id,
    size: size
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def get_followed_user user
    current_user.active_relationships.find_by followed_id: user.id
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.index.not_found"
    redirect_to root_path
  end
end
