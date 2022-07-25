class User < ApplicationRecord
  belongs_to :organization

  validates_uniqueness_of :email

  def self.authenticate(organization, email, password)
    user = find_by_email(email)
    if user && user.password_digest == password && user.organization == organization
      user
    else
      nil
    end
  end
end
