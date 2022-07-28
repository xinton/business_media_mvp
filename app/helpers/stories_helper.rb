module StoriesHelper
  # Give view access
  include StoriesPolicy

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
end
