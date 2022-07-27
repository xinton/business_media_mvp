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
end
