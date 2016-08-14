require 'rails_helper'

RSpec.describe King, type: :model do
  let(:king) { FactoryGirl.create(:king) }
  let(:game) { FactoryGirl.create(:game) }
  let(:black_king) { FactoryGirl.create(:king, row_coordinate: 0, column_coordinate: 4, game_id: game.id) }
  let(:queen_side_black_rook) { FactoryGirl.create(:rook, row_coordinate: 0, column_coordinate: 0, game_id: game.id) }
  let(:king_side_black_rook) { FactoryGirl.create(:rook, row_coordinate: 0, column_coordinate: 7, game_id: game.id) }

  describe 'can_castle?' do
    before do
      game
      Piece.destroy_all
    end
    context 'queen side castle' do
      it 'should return false if there are pieces between king and rook' do
        FactoryGirl.create(:bishop, row_coordinate: 0, column_coordinate: 2, game_id: game.id)
        expect(black_king.can_castle?(queen_side_black_rook)).to eq false
      end

      it 'should return false if king is in check' do
        FactoryGirl.create(:rook, color: 'white', row_coordinate: 4, column_coordinate: 4, game_id: game.id)
        expect(black_king.can_castle?(queen_side_black_rook)).to eq false
      end

      it 'should return false if king passes through a square that is attacked by enemy piece' do
        FactoryGirl.create(:rook, color: 'white', row_coordinate: 2, column_coordinate: 3, game_id: game.id)
        expect(black_king.can_castle?(queen_side_black_rook)).to eq false
      end

      it 'should return false if king ends up in check' do
        FactoryGirl.create(:rook, color: 'white', row_coordinate: 2, column_coordinate: 2, game_id: game.id)
        expect(black_king.can_castle?(queen_side_black_rook)).to eq false                
      end

      it 'should return false if king has moved' do
        black_king.update_attributes(has_moved?: true)
        expect(black_king.can_castle?(queen_side_black_rook)).to eq false
      end

      it 'should return false if rook has moved' do
        queen_side_black_rook.update_attributes(has_moved?: true)
        expect(black_king.can_castle?(queen_side_black_rook)).to eq false
      end

      it 'should return true if king and rook satisfies above requirements' do
        expect(black_king.can_castle?(queen_side_black_rook)).to eq true
      end
    end

    context 'king side castle' do
      it 'should return false if there are pieces between king and rook' do
        FactoryGirl.create(:bishop, row_coordinate: 0, column_coordinate: 5, game_id: game.id)
        expect(black_king.can_castle?(king_side_black_rook)).to eq false        
      end

      it 'should return false if king is in check' do
        FactoryGirl.create(:rook, color: 'white', row_coordinate: 4, column_coordinate: 4, game_id: game.id)
        expect(black_king.can_castle?(king_side_black_rook)).to eq false
      end

      it 'should return false if king passes through a square that is attacked by enemy piece' do
        FactoryGirl.create(:rook, color: 'white', row_coordinate: 4, column_coordinate: 5, game_id: game.id)
        expect(black_king.can_castle?(king_side_black_rook)).to eq false        
      end

      it 'should return false if king ends up in check' do
        FactoryGirl.create(:rook, color: 'white', row_coordinate: 4, column_coordinate: 6, game_id: game.id)
        expect(black_king.can_castle?(king_side_black_rook)).to eq false                
      end

      it 'should return false if king has moved' do
        black_king.update_attributes(has_moved?: true)
        expect(black_king.can_castle?(king_side_black_rook)).to eq false        
      end

      it 'should return false if rook has moved' do
        king_side_black_rook.update_attributes(has_moved?: true)
        expect(black_king.can_castle?(king_side_black_rook)).to eq false        
      end

      it 'should return true if king and rook satisfies above requirements' do
        expect(black_king.can_castle?(king_side_black_rook)).to eq true        
      end
    end
  end

  describe 'valid_move?' do
    it 'should return true when the king moves up or down one row' do
      expect(king.valid_move?(4, 3)).to eq true
      expect(king.valid_move?(2, 3)).to eq true
    end

    it 'should return true when the king moves left or right one column' do
      expect(king.valid_move?(3, 2)).to eq true
      expect(king.valid_move?(3, 4)).to eq true
    end

    it 'should return true when the king moves diagonally' do
      expect(king.valid_move?(4, 2)).to eq true
      expect(king.valid_move?(4, 4)).to eq true
      expect(king.valid_move?(2, 2)).to eq true
      expect(king.valid_move?(2, 4)).to eq true
    end

    it 'should return false when the king moves up or down more than one row' do
      expect(king.valid_move?(6, 3)).to eq false
      expect(king.valid_move?(1, 3)).to eq false
    end

    it 'should return false when the king moves left or right more than one column' do
      expect(king.valid_move?(3, 1)).to eq false
      expect(king.valid_move?(3, 6)).to eq false
    end

    it 'should return false when the king moves more than one row/column diagonally' do
      expect(king.valid_move?(5, 2)).to eq false
      expect(king.valid_move?(5, 4)).to eq false
      expect(king.valid_move?(1, 2)).to eq false
      expect(king.valid_move?(1, 4)).to eq false
    end
  end
end
