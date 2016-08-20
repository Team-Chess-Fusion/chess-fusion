require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:fullgame) { FactoryGirl.create(:full_game) }
  let(:piece) { FactoryGirl.create(:piece) }

  before do
    fullgame.populate_board!
  end

  describe '#update' do
    context 'user signed in' do
      before do
        sign_in user
      end
      it 'should update piece position' do
        knight = fullgame.pieces.where('type = ? AND color = ?', 'Knight', 'white').first
        puts knight.inspect
        patch :update, id: knight.id, piece: {
          row_coordinate: 2,
          column_coordinate: 2
        }

        knight.reload

        expect(knight.row_coordinate).to eq 2
        expect(knight.column_coordinate).to eq 2
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
