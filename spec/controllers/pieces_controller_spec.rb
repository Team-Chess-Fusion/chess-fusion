require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:fullgame) { FactoryGirl.create(:full_game) }
  let(:piece) { FactoryGirl.create(:piece) }

  describe '#promote_pawn' do
    context 'user signed in' do
      before do
        sign_in user
      end
      it 'should upgrade pawn to selected type' do
        promoted_pawn = fullgame.pieces.create(type: 'Pawn', color: 'black', row_coordinate: 0, column_coordinate: 0)

        put :promote_pawn, piece_id: promoted_pawn.id, piece: {
          type: 'Queen'
        }

        new_piece = Queen.last

        expect(new_piece.type).to eq 'Queen'
        expect(new_piece.color).to eq 'black'
        expect(new_piece.row_coordinate).to eq 0
        expect(new_piece.column_coordinate).to eq 0
      end
    end
  end

  describe '#update' do
    before do
      fullgame.populate_board!
      allow(Pusher).to receive(:trigger)
    end
    context 'user signed in' do
      before do
        sign_in user
      end
      it 'should update piece position' do
        knight = fullgame.pieces.where('type = ? AND color = ?', 'Knight', 'white').first
        patch :update, id: knight.id, piece: {
          row_coordinate: 2,
          column_coordinate: 2
        }

        knight.reload

        expect(knight.row_coordinate).to eq 2
        expect(knight.column_coordinate).to eq 2
        expect(Pusher).to have_received(:trigger).with("game_channel-#{fullgame.id}",
                                                       'moved',
                                                       current_user: user.id,
                                                       color_moved: 'white',
                                                       origin_square: { row: 0, col: 1 },
                                                       destination_square: { row: 2, col: 2 },
                                                       stalemate: false,
                                                       in_check: false)
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
