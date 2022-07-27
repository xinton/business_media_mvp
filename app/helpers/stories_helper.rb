module StoriesHelper
  def chief?
    current_user.role == "chief"
  end

  def story_chief?
    chief? && current_user.id == @story.chief&.id
  end

  def writer?
    current_user.role == "writer"
  end

  def story_write?
    writer? && current_user.id == @story.writer&.id
  end

  def can_write?
    story_write? && ["draft", "pending"].include?(@story.status)
  end

  def reviewer?
    current_user.role == "reviewer"
  end

  def story_reviewer?
    reviewer? && current_user.id == @story.reviewer&.id
  end

  def can_review?
    story_reviewer? && ["in_review", "for_review"].include?(@story.status)
  end
end
