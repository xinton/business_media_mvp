class User < ApplicationRecord
  has_many :chiefing_stories, :class_name => 'Story', :foreign_key => 'chief_id'
  has_many :write_stories, :class_name => 'Story', :foreign_key => 'writer_id'
  has_many :revised_stories, :class_name => 'Story', :foreign_key => 'reviewer_id'
  
  belongs_to :organization

  validates :name, :email, :organization, presence: true

  validates_uniqueness_of :email

  def self.authenticate(organization, email, password)
    user = find_by_email(email)
    user && user.password_digest == password && user.organization.slug == organization ? user : nil
  end
end
