require 'rails_helper'

RSpec.describe Story, type: :model do
  organization = Organization.first_or_create!(name:'example organization', slug: 'exorg')
  current_user = User.first_or_create!(name:'example user', email: 'dean@example.com', password_digest: 'password', role: 'chief', organization: organization)
  describe 'attributes validation' do
    it 'has a organization' do
      story = Story.new(
        headline: 'A valid headline',
        body: 'A Valid Body',
        status: '',
        chief: current_user,
      )
      expect(story).to_not be_valid
  
      story.organization = organization
      expect(story).to be_valid
    end
  end
end



