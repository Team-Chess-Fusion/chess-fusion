require 'rails_helper'

RSpec.describe Pawn, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:pawn) { FactoryGirl.create(:pawn, game_id: game.id) }
  let!(:black_king) { FactoryGirl.create(:king, game_id: game.id, row_coordinate: 7, column_coordinate: 4, color: 'black') }
  let!(:white_king) { FactoryGirl.create(:king, game_id: game.id, row_coordinate: 0, column_coordinate: 4, color: 'white') }
  let(:b_pawn) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 1, color: 'black') }
  let(:w_pawn) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 2, column_coordinate: 1, color: 'white') }
  let(:b_pawn_2) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 7, color: 'black') }
  let(:b_pawn_3) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 5, color: 'black') }
  let(:w_pawn_2) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 5, column_coordinate: 5, color: 'white') }
  let(:white_pawn_1) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 2, color: 'white') }
  let(:black_pawn_1) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 3, column_coordinate: 3, color: 'black') }
  let(:white_pawn_2) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 4, column_coordinate: 2, color: 'white') }
  let(:black_pawn_2) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 3, color: 'black') }
  let(:white_pawn_3) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 4, color: 'white') }
  let(:black_pawn_3) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 4, color: 'black') }
  let(:white_pawn_4) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 5, color: 'white') }
  let(:black_pawn_4) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 3, column_coordinate: 6, color: 'black') }
  let(:white_pawn_5) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 4, column_coordinate: 7, color: 'white') }
  let(:black_pawn_5) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 6, color: 'black') }
  let(:white_pawn_6) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 1, color: 'white') }
  let(:black_pawn_6) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 1, color: 'black') }
  let(:white_pawn_7) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 4, column_coordinate: 1, color: 'white') }
  let(:black_pawn_7) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 2, color: 'black') }
  let(:white_pawn_8) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 7, color: 'white') }
  let(:black_pawn_8) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 5, column_coordinate: 7, color: 'black') }
  let(:white_pawn_9) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 5, column_coordinate: 2, color: 'white') }
  let(:black_pawn_9) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 3, column_coordinate: 2, color: 'black') }
  let(:white_rook) { FactoryGirl.create(:rook, color: 'white', row_coordinate: 4, column_coordinate: 4, game_id: game.id) }

  describe 'valid_move? for pawn method' do
    it 'should return true' do
      expect(b_pawn.valid_move?(4, 1)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(5, 1)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(5, 2)).to eq false
    end

    it 'should return true if diagonal move is a capture' do
      white_pawn_9
      expect(b_pawn.valid_move?(5, 2)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(5, 0)).to eq false
    end

    it 'should return false' do
      expect(b_pawn.valid_move?(3, 1)).to eq false
    end

    it 'should return false' do
      expect(b_pawn.valid_move?(5, 3)).to eq false
    end

    it 'should return false' do
      expect(w_pawn.valid_move?(4, 1)).to eq false
    end

    it 'should return true' do
      expect(w_pawn.valid_move?(3, 1)).to eq true
    end

    it 'should return false for diagonal move' do
      expect(w_pawn.valid_move?(3, 2)).to eq false
    end

    it 'should return true for diagonal move if square is occupied' do
      black_pawn_9
      expect(w_pawn.valid_move?(3, 2)).to eq true
    end

    it 'should return false' do
      expect(b_pawn_2.valid_move?(3, 7)).to eq false
    end

    it 'should return false' do
      obstructed_check = Piece::Obstructed.new(game, b_pawn_3, 4, 5)
      expect(w_pawn_2.row_coordinate).to eq 5
      expect(w_pawn_2.column_coordinate).to eq 5
      expect(obstructed_check.run).to eq true
      expect(b_pawn_3.valid_move?(4, 5)).to eq false
      expect(b_pawn_3.valid_move?(5, 5)).to eq false
    end
  end

  describe 'enpassant_status' do
    it 'should return false if it moves only one row' do
      pawn.move_to!(2, 1)
      pawn.change_enpassant_status
      expect(pawn.en_passant).to eq false
    end

    it 'should return false if it moves to row 3 in two moves' do
      white_pawn_6.move_to!(2, 1)
      white_pawn_6.change_enpassant_status
      expect(white_pawn_6.en_passant).to eq false
      white_pawn_6.move_to!(3, 1)
      white_pawn_6.change_enpassant_status
      expect(white_pawn_6.en_passant).to eq false
    end

    it 'should return true if it moves two rows from starting coordinate' do
      expect(white_pawn_3.en_passant).to eq nil
      white_pawn_3.move_to!(3, 4)
      white_pawn_3.change_enpassant_status
      expect(white_pawn_3.en_passant).to eq true
    end

    it 'should return false if it moves away from the en passant eligible row ' do
      expect(white_pawn_3.en_passant).to eq nil
      white_pawn_3.move_to!(3, 4)
      white_pawn_3.change_enpassant_status
      expect(white_pawn_3.en_passant).to eq true
      white_pawn_3.move_to!(4, 4)
      white_pawn_3.change_enpassant_status
      expect(white_pawn_3.en_passant).to eq false
    end
  end

  describe '#capture_for_enpassant' do
    context 'black pawn capturing white pawn' do
      it 'should allow black pawn to capture white pawn' do
        expect(game.current_move_color).to eq 'white'
        expect(white_pawn_1.en_passant).to eq nil
        expect(white_pawn_1.move_to!(3, 2)).to eq 'moved'
        expect(white_pawn_1.row_coordinate).to eq 3
        expect(white_pawn_1.column_coordinate).to eq 2
        expect(white_pawn_1.change_enpassant_status).to eq true
        black_pawn_1.capture_for_enpassant
        white_pawn_1.reload
        expect(white_pawn_1.column_coordinate).to eq nil
        expect(white_pawn_1.row_coordinate).to eq nil
        black_pawn_1.reload
        expect(black_pawn_1.column_coordinate).to eq 2
        expect(black_pawn_1.row_coordinate).to eq 2
      end

      it 'should not allow black pawn to capture white pawn' do
        white_pawn_4.move_to!(2, 5)
        white_pawn_4.change_enpassant_status
        white_pawn_4.reload
        white_pawn_4.move_to!(3, 5)
        expect(white_pawn_4.en_passant).to eq false
        expect(black_pawn_4.capture_for_enpassant).to eq false
      end

      it 'should not allow user to capture if next move skips en passant' do
        game.update_attributes(current_move_color: 'black')
        expect(game.current_move_color).to eq 'black'
        expect(black_pawn_7.en_passant).to eq nil
        expect(black_pawn_7.move_to!(4, 2)).to eq 'moved'
        black_pawn_7.reload
        black_pawn_7.change_enpassant_status
        expect(black_pawn_7.row_coordinate).to eq 4
        expect(black_pawn_7.en_passant).to eq true
        game.reload
        expect(game.current_move_color).to eq 'white'
        white_rook.move_to!(4, 5)
        game.reload
        black_pawn_7.change_enpassant_status
        expect(game.current_move_color).to eq 'black'
        expect(black_pawn_7.en_passant).to eq false
        expect(white_pawn_7.capture_for_enpassant).to eq false
      end

      it 'should return false for en passant if black pawn uses multiple turns to reach row 3' do
        expect(white_pawn_8.en_passant).to eq nil
        white_pawn_8.move_to!(3, 7)
        white_pawn_8.change_enpassant_status
        expect(white_pawn_8.en_passant).to eq true
        game.reload
        expect(game.current_move_color).to eq 'black'
        black_pawn_8.move_to!(4, 6)
        black_pawn_8.reload
        game.reload
        white_pawn_8.change_enpassant_status
        expect(white_pawn_8.en_passant).to eq false
        black_pawn_8.move_to!(3, 6)
        expect(black_pawn_8.capture_for_enpassant).to eq false
      end
    end

    context 'white pawn capturing black pawn' do
      it 'should allow white pawn to capture black pawn' do
        game.update_attributes(current_move_color: 'black')
        expect(game.current_move_color).to eq 'black'
        expect(black_pawn_2.en_passant).to eq nil
        expect(black_pawn_2.move_to!(4, 3)).to eq 'moved'
        expect(black_pawn_2.row_coordinate).to eq 4
        expect(black_pawn_2.column_coordinate).to eq 3
        expect(black_pawn_2.change_enpassant_status).to eq true
        white_pawn_2.capture_for_enpassant
        black_pawn_2.reload
        expect(black_pawn_2.column_coordinate).to eq nil
        expect(black_pawn_2.row_coordinate).to eq nil
        white_pawn_2.reload
        expect(white_pawn_2.column_coordinate).to eq 3
        expect(white_pawn_2.row_coordinate).to eq 5
      end

      it 'should not allow white pawn to capture black pawn' do
        black_pawn_5.move_to!(5, 6)
        black_pawn_5.change_enpassant_status
        black_pawn_5.reload
        black_pawn_5.move_to!(4, 6)
        expect(white_pawn_5.capture_for_enpassant).to eq false
      end
    end
  end
end
