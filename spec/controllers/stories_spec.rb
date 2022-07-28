require 'rails_helper'
include StoriesHelper

RSpec.describe '/stories', type: :request do
  organization = Organization.first_or_create!(name:'example organization', slug: 'exorg')
  current_user = User.first_or_create!(name:'example user', email: 'dean@example.com', password_digest: 'password', role: 'chief', organization: organization)
  
  story = Story.new(
    id: 1,
    headline: 'A valid headline',
    body: 'A Valid Body',
    status: '',
    chief: current_user,
    organization: organization
  )

  valid_attributes = {
    id: 1,
    headline: 'A valid headline',
    body: 'A Valid Body',
    status: '',
    chief_id: 1,
    organization_id: 1
  }

  def login(role)
    organization = Organization.first_or_create!(name:'example organization', slug: 'exorg')
    user = User.new(name:'example user', email: 'dean@example.com', password_digest: 'password', role: role, organization: organization)
    user.save

    get "/sessions/new"
    post "/sessions", :params => { organization: organization.slug, email: 'dean@example.com', password: 'password'} 
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      login('chief')
      get stories_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      login('chief')

      story.save
      get story_url(story)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'must access with chief role' do
      login('chief')

      get new_story_url
      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it 'must not access with writer role' do
      login('writer')

      get new_story_url
      expect(response.status).to eq(302)
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      login('chief')
      story = Story.new(valid_attributes)
      story.save
      get edit_story_url(story)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with chief role' do
      before :each do
        login('chief')
      end

      it 'must create history' do
        expect do
          #story = Story.new(valid_attributes)
          story.save
          post stories_url, params: { story: valid_attributes }
          expect(response).to redirect_to(stories_url)
          expect(flash[:alert]).to match("Created")
        end.to change(Story, :count).by(1)
      end
    end

    context 'with writer role' do
      before :each do
        login('writer')
      end

      it 'must not create history' do
        expect do
          #story = Story.new(valid_attributes)
          story.save
          post stories_url, params: { story: valid_attributes }
          expect(response).to redirect_to(stories_url)
          expect(flash[:alert]).to match("Action unauthorized")
        end.to change(Story, :count).by(0)
      end
    end
  end

end