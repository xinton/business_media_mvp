class StoriesController < ApplicationController
  include StoriesHelper

  before_action :authorize
  before_action :create_authorized? , only: [:new, :create]

  def create_authorized?
    unless chief?
      flash.alert = "Action unauthorized"
      redirect_to stories_path
    end
  end
  
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

    @story.writer = article_params[:writer_id].present? ? User.find(article_params[:writer_id]) : nil
    @story.reviewer = article_params[:reviewer_id].present? ? User.find(article_params[:reviewer_id]) : nil
    
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
      params.require(:story).permit(:headline, :body, :status, :chief, :organization, :writer, :writer_id, :reviewer, :reviewer_id)
    end

    def handle_writer_on_creation
      if article_params[:writer_id].present?
        @story.writer = User.find(article_params[:writer_id])
        @story.create_with_writer
      else
        @story.create_without_writer
      end
    end

    def current_action_text
      #TODO change to hash array
      case @story.status
      when 'unassigned'
        "SAVE"
      when 'draft'
        "REQUEST REVIEW"
      when 'for_review'
        "REVIEW"
      when 'in_review'
        "APPROVE"
      when 'approved'
        "PUBLISH"
      else
        "Save"
      end
    end
    
    def current_action_permission
      reviwer_status = ['for_review', 'in_review', 'pending']

      case @story.status
      when 'unassigned'
        "SAVE"
      when 'draft'
        story_write?
      when *reviwer_status
        story_reviewer?
      when 'approved'
        story_chief?
      else
        "Save"
      end
    end

    def handle_state
      case @story.status
      when 'unassigned'
        @story.assign_writer
      when 'draft'
        @story.request_review    
      when 'for_review'
        @story.start_review   
      when 'in_review'
        @story.approve 
      when 'approved'
        @story.publish   
      else
        "Error"
      end
    end

    helper_method :current_action_text, :current_action_permission
end
