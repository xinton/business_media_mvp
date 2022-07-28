module UpdateEmergencyFix
  extend ActiveSupport::Concern

  def writer_verification
    if article_params[:writer_id].present?
      @story.writer = User.find(article_params[:writer_id])
    elsif @story.writer
      @story.writer = @story.writer
    end
  end

  def reviewer_verification
    if article_params[:reviewer_id].present?
      @story.reviewer = User.find(article_params[:reviewer_id])
    elsif @story.reviewer
      @story.reviewer = @story.reviewer
    end
  end
end