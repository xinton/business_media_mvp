module ApplicationHelper
  # TODO actual organization on session[]
  def organization_name
    current_user ? organization = Organization.find_by_id(current_user.organization_id) : nil
    current_user && organization ? organization.name : nil
  end
end
