require 'rails_helper'

RSpec.describe '/sessions', type: :request do
  describe 'POST /create' do
    it 'must login with correct parameters' do
      organization = Organization.first_or_create!(name:'example organization', slug: 'exorg')
      user = User.new(name:'example user', email: 'dean@example.com', password_digest: 'password', role: 'chief', organization: organization)
      user.save

      get "/sessions/new"
      expect(response).to render_template(:new)

      post "/sessions", :params => { organization: 'exorg', email: 'dean@example.com', password: 'password'} 
      # TODO in controller has a redirect_to
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
    end

    it 'must not login with incorrect parameters' do
      get "/sessions/new"
      expect(response).to render_template(:new)

      post "/sessions", :params => { organization: 'exorg', email: 'dean@example.com', password: 'wrong password'} 
      # TODO in controller has a redirect_to
      expect(flash[:alert]).to match('Email or password is invalid')
    end
  end
end