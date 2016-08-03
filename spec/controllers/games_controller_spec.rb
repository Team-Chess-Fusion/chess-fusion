require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:single_player_game) { FactoryGirl.create(:single_player_game) }
  let(:full_game) { FactoryGirl.create(:full_game) }
  describe '#update' do
    context 'user is signed in' do
      before do
        sign_in user
      end
      it 'should allow user to join a game' do
        post :update, id: single_player_game.id
        single_player_game.reload
        expect(single_player_game.black_player_id).to eq user.id
        expect(response).to redirect_to root_path
      end
      it 'should return a 404 error if game is not found' do
        post :update, id: 'POKEMON GO'
        single_player_game.reload
        expect(single_player_game.black_player_id).to be_nil
        expect(response).to have_http_status(:not_found)
      end
      it 'should return unauthorized if game is full' do
        post :update, id: full_game
        puts full_game.white_player
        full_game.reload
        expect(full_game.white_player_id).to eq(1)
        expect(full_game.black_player_id).to eq(3)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'user is not signed in' do
      it 'should redirect user to sign in page' do
        post :update, id: single_player_game.id
        single_player_game.reload
        expect(single_player_game.black_player_id).to be_nil
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
