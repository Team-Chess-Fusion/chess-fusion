require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#show' do
    context 'user signed in' do
      it 'should display the page for current user' do
        u = FactoryGirl.create(:user)
        sign_in u
        get :show, id: u.id
        expect(response).to have_http_status(:success)
      end
    end

    context 'user not signed in' do
      it 'should display the page for current user' do
        u = FactoryGirl.create(:user)
        get :show, id: u.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
