module StoriesHelper
  # Give view access
  include StoriesPolicy

  def has_writer_id(form)
    form.object[:writer_id] ? form.object[:writer_id] : nil
  end

  def hidde_writer_select?(form, form_select)
    if form_select
      has_writer_id(form) ? "hidden" : "display_block"
    elsif 
      has_writer_id(form) ? "display_block" : "hidden"
    end
  end

  def has_reviewer_id(form)
    form.object[:reviewer_id] ? form.object[:reviewer_id] : nil
  end

  def hidde_reviewer_select?(form, form_select)
    if form_select
      has_reviewer_id(form) ? "hidden" : "display_block"
    elsif 
      has_reviewer_id(form) ? "display_block" : "hidden"
    end
  end

  def handle_writer_on_creation
    if article_params[:writer_id].present?
      @story.writer = User.find(article_params[:writer_id])
      @story.create_with_writer
    else
      @story.create_without_writer
    end
  end

  def show_second_btn?
    ["in_review", "approved"].include?(@story.status) ? "display_block" : "hidden"
  end

  def current_action_text
    #TODO change to hash array
    case @story.status
    when 'unassigned'
      {main_btn: "SAVE"}
    when 'draft'
      {main_btn: "REQUEST REVIEW"}
    when 'for_review'
      {main_btn: "REVIEW"}
    when 'in_review'
      {main_btn: "APPROVE", second_btn: "REQUEST CHANGES"}
    when 'approved'
      {main_btn: "PUBLISH", second_btn: "ARCHIVE"}
    else
      {main_btn: "Save", second_btn: "cancel"}
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
      @story.assign_writer if @story.writer.present?
    when 'draft'
      @story.request_review if @story.writer.present? && @story.reviwer.present? && @story.body.present?  
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
