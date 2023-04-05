class MoodTagsController < ApplicationController
  def index
    @mood_tags = MoodTag.all
  end

  def show
    @mood_tag = MoodTag.find(params[:id])
  end
end
