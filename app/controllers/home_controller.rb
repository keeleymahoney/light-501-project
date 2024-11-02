class HomeController < ApplicationController
  def index
  end
  def media
    # Code for media page
  end
  def featured
    # Code for featured page
  end
  def about
    # Code for about page
  end

  def event
    @prevEvents = Event.where("date < ?", Date.current).where(published: true).order(date: :desc)
    @currentEvents = Event.where("date >= ?", Date.current).where(published: true).order(date: :asc)

  end
end
