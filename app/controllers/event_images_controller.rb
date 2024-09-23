# frozen_string_literal: true

class EventImagesController < ApplicationController
  def create(event, image)
    @event_image = event.event_images.build(picture: image)

    return true if @event_image.save

    render :new, status: :unprocessable_entity
  end

  def destroy
    @event_image.destroy
  end

  # def event_image_params
  #   image = params[:eventimage][:picture]
  #   { picture: image.read } if image.present?
  # end
end
