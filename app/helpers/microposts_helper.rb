module MicropostsHelper
  def resize_image image
    image.variant resize_to_limit: Settings.image.image_micropost_size
  end
end
