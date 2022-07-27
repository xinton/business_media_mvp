module StoriesHelper
  def chief?
    current_user.role == "chief"
  end

  def writer?
    current_user.role == "writer"
  end

  def reviewer?
    current_user.role == "reviewer"
  end

  def can_write?
    writer? && current_user.id == @story.writer.id
  end
end
