require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:fullgame) { FactoryGirl.create(:full_game) }
  let(:piece) { FactoryGirl.create(:game) }

  describe '#show' do
    context 'user signed in' do    
      it 'should show game board with http status success' do
        get :show, game_id: fullgame.id, id: fullgame.pieces.first.id
        expect(response).to have_http_status(:success)
      end
      it 'should return 404 error if piece not found' do
      end
    end

    context 'user not signed in' do
      it 'should redirect user to sign in page' do
      end
    end
  end

  describe '#update' do
    context 'user signed in' do
      it 'should update piece position' do
      end
    end

    context 'user not signed in' do
      it 'should redirect user to sign in page' do
      end
    end
  end

end
