require 'rails_helper'
RSpec.describe User, type: :model do
  describe 'User creation' do
    it 'attributes must be instantiated on creation' do
      # missing attributes
      user = User.new(name: 'Abraham', email: 'email@test.com')
      user.save
      expect(user.save).to eq(false)
    end
  end
end