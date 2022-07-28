class StoriesController < ApplicationController
  include StoriesHelper
  include StoriesPolicy
  include UpdateEmergencyFix

  before_action :authorize
  before_action :create_authorized? , only: [:new, :create]

  def index
    @stories = Story.where(organization_id: current_user.organization_id).all
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
    @story.reviewer = article_params[:reviewer_id].present? ? User.find(article_params[:reviewer_id]) : nil
    
    handle_writer_on_creation

    if @story.save
      flash.alert = "Story Created!"
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

    # Emergency workaround: the 'selected:' option from 'form.select' are not working correct
    writer_verification
    reviewer_verification

    # state machine
    handle_state

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
      params.require(:story).permit(:headline, :body, :status, :chief, :organization, :writer, :writer_id, :reviewer, :reviewer_id, :main_button)
    end

    helper_method :current_action_text, :current_action_permission
end
