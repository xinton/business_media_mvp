class StoriesController < ApplicationController
  before_action :authorize
  
  def index
    @stories = Story.all
  end

  def show
    @story = Story.find(params[:id])
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(article_params)
    @story.organization = current_user.organization
    @story.chief = current_user

    writer_on_creation
    @story.reviewer = article_params[:reviewer_id].present? ? User.find(article_params[:reviewer_id]) : nil

    if @story.save
      redirect_to stories_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])

    if @story.update(article_params)
      redirect_to @story
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    redirect_to root_path, status: :see_other
  end
  
  private
    def article_params
      params.require(:story).permit(:headline, :body, :chief, :organization, :writer_id, :reviewer_id)
    end

    def writer_on_creation
      if ( article_params[:writer_id].present? )
        @story.writer =  User.find(article_params[:writer_id])
        @story.create_with_writer
      else
        @story.create_without_writer
      end
    end
end
