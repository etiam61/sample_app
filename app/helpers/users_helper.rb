module UsersHelper
  def gravatar_for user, size = Settings.image.avatar_size
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = t "users.helper.gravatar_link", gravatar_id: gravatar_id,
    size: size
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
end
