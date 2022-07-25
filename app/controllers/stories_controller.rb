class StoriesController < ApplicationController
  before_action :authorize
  
  def index
    @stories = Story.all
  end
end
