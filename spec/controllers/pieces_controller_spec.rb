require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:fullgame) { FactoryGirl.create(:full_game) }
  let(:piece) { FactoryGirl.create(:piece) }

  describe '#show' do
    context 'user signed in' do
      before do
        sign_in user
      end
      it 'should show game board with http status success' do
        get :show, game_id: fullgame.id, id: fullgame.pieces.first.id

        expect(response).to have_http_status(:success)
      end
      it 'should return 404 error if piece not found' do
        get :show, game_id: fullgame.id, id: 'some id'

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'user not signed in' do
      it 'should redirect user to sign in page' do
        get :show, game_id: fullgame.id, id: fullgame.pieces.first.id

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#update' do
    context 'user signed in' do
      before do
        sign_in user
      end
      it 'should update piece position' do
        patch :update, id: fullgame.pieces.first.id, piece: {
          row_coordinate: 4,
          column_coordinate: 5
        }

        fullgame.pieces.first.reload

        expect(fullgame.pieces.first.row_coordinate).to eq 4
        expect(fullgame.pieces.first.column_coordinate).to eq 5
      end

      it 'should return 404 error if piece not found' do
        patch :update, id: 'pieceid', piece: {
          row_coordinate: 4,
          column_coordinate: 5
        }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'user not signed in' do
      it 'should redirect user to sign in page' do
        patch :update, id: fullgame.pieces.first.id, piece: {
          row_coordinate: 4,
          column_coordinate: 5
        }

        fullgame.pieces.first.reload

        expect(fullgame.pieces.first.row_coordinate).to eq 0
        expect(fullgame.pieces.first.column_coordinate).to eq 0
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
