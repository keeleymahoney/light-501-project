class EventImagesController < ApplicationController
  def create(event, image)
    @event_image = event.event_images.build(picture: image)

    if @event_image.save
      return true
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @event_image.destroy
  end

  private

  # def event_image_params
  #   image = params[:eventimage][:picture]
  #   { picture: image.read } if image.present?
  # end
end

