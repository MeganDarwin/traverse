module ImageResizable
  extend ActiveSupport::Concern

  # Resizes an array of images to the specified width and height
  #
  # @param images [Array<ActionDispatch::Http::UploadedFile>] an array of uploaded image files
  # @param width [Integer] the width to resize the images to
  # @param height [Integer] the height to resize the images to
  def resize_images(images, width, height)
    return unless images.present?

    images.each do |image|
      resize_image(image, width, height)
    end
  end

  # Resizes a single image to the specified width and height
  #
  # @param image [ActionDispatch::Http::UploadedFile] an uploaded image file
  # @param width [Integer] the width to resize the image to
  # @param height [Integer] the height to resize the image to
  def resize_image(image, width, height)
    return unless image.present?
    begin
      processed_image = MiniMagick::Image.read(image.tempfile.path)
      processed_image.resize "#{width}x#{height}>"
      processed_image.write(image.tempfile.path)
    rescue StandardError => e
      Rails.logger.error "Image resizing failed: #{e.message}"
      Rails.logger.error "Image path: #{image.tempfile.path}"
      Rails.logger.error "Image content type: #{image.content_type}"
    end
  end
end
