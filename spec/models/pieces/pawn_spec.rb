require 'rails_helper'

RSpec.describe Pawn, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:pawn) { FactoryGirl.create(:pawn) }
  let(:b_pawn) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 1, color: 'black') }
  let(:w_pawn) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 5, column_coordinate: 1, color: 'white') }
  let(:b_pawn_2) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 2, color: 'black') }
  let(:b_pawn_3) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 5, color: 'black') }
  let(:w_pawn_2) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 2, column_coordinate: 5, color: 'white') }

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

  describe 'valid_move? for pawn method' do
    it 'should return true' do
      expect(b_pawn.valid_move?(3, 1)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(2, 1)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(2, 2)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(2, 0)).to eq true
    end

    it 'should return false' do
      expect(b_pawn.valid_move?(4, 1)).to eq false
    end

    it 'should return false' do
      expect(b_pawn.valid_move?(2, 3)).to eq false
    end

    it 'should return false' do
      expect(w_pawn.valid_move?(3, 1)).to eq false
    end

    it 'should return true' do
      expect(w_pawn.valid_move?(4, 1)).to eq true
    end

    it 'should return false' do
      expect(b_pawn_2.valid_move?(4, 2)).to eq false
    end

    it 'should return false' do
      expect(w_pawn_2.row_coordinate).to eq 2
      expect(w_pawn_2.column_coordinate).to eq 5
      expect(b_pawn_3.obstructed?(3, 5)).to eq true
      expect(b_pawn_3.valid_move?(3, 5)).to eq false
      expect(b_pawn_3.valid_move?(2, 5)).to eq false
    end
  end

  describe '#change_enpassant_status' do
    it 'should return false if it moves one row' do
      pawn.move_to!(2, 1)
      pawn.change_enpassant_status
      expect(pawn.en_passant).to eq false
    end

    it 'should return nil if it moves two rows from starting coordinate' do
      white_pawn_3.move_to!(3, 4)
      white_pawn_3.change_enpassant_status
      expect(white_pawn_3.en_passant).to eq nil
    end
  end

  describe '#capture_for_enpassant' do
    context 'black pawn capturing white pawn' do
      it 'should allow black pawn to capture white pawn' do
        white_pawn_1.move_to!(3, 2)
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
        expect(black_pawn_4.capture_for_enpassant).to eq false
      end
    end

    context 'white pawn capturing black pawn' do
      it 'should allow white pawn to capture black pawn' do
        black_pawn_2.move_to!(4, 3)
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
