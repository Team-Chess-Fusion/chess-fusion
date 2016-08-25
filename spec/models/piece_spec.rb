require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:black_king) { FactoryGirl.create(:king, row_coordinate: 0, column_coordinate: 4, game_id: game.id) }
  let(:queen_side_black_rook) { FactoryGirl.create(:rook, row_coordinate: 0, column_coordinate: 0, game_id: game.id) }

  before :each do
    @game = FactoryGirl.create(:game)
    @b_rook_1 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Rook', color: 'black', row_coordinate: 0, column_coordinate: 0)
    @b_knight_1 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Knight', color: 'black', row_coordinate: 0, column_coordinate: 1)
    @b_king = FactoryGirl.create(:piece, game_id: @game.id, type: 'King', color: 'black', row_coordinate: 0, column_coordinate: 3)
    @b_bishop_1 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Bishop', color: 'black', row_coordinate: 0, column_coordinate: 5)
    @b_bishop_2 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Bishop', color: 'black', row_coordinate: 5, column_coordinate: 7)
    @b_knight_2 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Knight', color: 'black', row_coordinate: 0, column_coordinate: 6)
    @b_rook_2 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Rook', color: 'black', row_coordinate: 0, column_coordinate: 7)
    @b_pawn_1 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'black', row_coordinate: 1, column_coordinate: 0)
    @b_pawn_2 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'black', row_coordinate: 1, column_coordinate: 1)
    @b_pawn_3 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'black', row_coordinate: 3, column_coordinate: 2)
    @b_pawn_4 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'black', row_coordinate: 1, column_coordinate: 4)
    @b_pawn_5 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'black', row_coordinate: 1, column_coordinate: 5)
    @b_pawn_6 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'black', row_coordinate: 1, column_coordinate: 6)
    @b_pawn_7 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'black', row_coordinate: 1, column_coordinate: 7)
    @w_knight_1 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Knight', color: 'white', row_coordinate: 3, column_coordinate: 3)
    @w_bishop_1 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Bishop', color: 'white', row_coordinate: 5, column_coordinate: 0)
    @w_pawn_1 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'white', row_coordinate: 5, column_coordinate: 1)
    @w_pawn_2 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'white', row_coordinate: 6, column_coordinate: 2)
    @w_pawn_3 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'white', row_coordinate: 6, column_coordinate: 3)
    @w_pawn_4 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'white', row_coordinate: 6, column_coordinate: 4)
    @w_pawn_5 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'white', row_coordinate: 6, column_coordinate: 5)
    @w_pawn_6 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'white', row_coordinate: 6, column_coordinate: 6)
    @w_pawn_7 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Pawn', color: 'white', row_coordinate: 6, column_coordinate: 7)
    @w_rook_1 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Rook', color: 'white', row_coordinate: 7, column_coordinate: 0)
    @w_king = FactoryGirl.create(:piece, game_id: @game.id, type: 'King', color: 'white', row_coordinate: 7, column_coordinate: 3)
    @w_queen = FactoryGirl.create(:piece, game_id: @game.id, type: 'Queen', color: 'white', row_coordinate: 7, column_coordinate: 4)
    @w_bishop_2 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Bishop', color: 'white', row_coordinate: 7, column_coordinate: 5)
    @w_knight_2 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Bishop', color: 'white', row_coordinate: 7, column_coordinate: 6)
    @w_rook_2 = FactoryGirl.create(:piece, game_id: @game.id, type: 'Rook', color: 'white', row_coordinate: 7, column_coordinate: 7)
  end

  describe 'move turn logic within #move_to! method' do
    let!(:game2) { FactoryGirl.create(:game) }
    let!(:white_pawn) { FactoryGirl.create(:pawn, game: game2, row_coordinate: 1, column_coordinate: 4, color: 'white') }
    let!(:black_pawn) { FactoryGirl.create(:pawn, game: game2, row_coordinate: 6, column_coordinate: 4, color: 'black') }

    it 'should return black to move' do
      expect(white_pawn.move_to!(2, 4)).to eq 'moved'
      game2.reload
      expect(game2.current_move_color).to eq 'black'
    end

    it 'should return invalid' do
      expect(black_pawn.move_to!(5, 4)).to eq 'invalid'
    end
  end

  describe 'move_to! method' do
    it 'should return moved' do
      expect(@w_knight_1.move_to!(4, 5)).to eq 'moved'
      @w_knight_1.reload
      expect(@w_knight_1.row_coordinate).to eq 4
      expect(@w_knight_1.column_coordinate).to eq 5
    end

    it 'should return castling if castling is possible' do
      game
      game.update_attributes(current_move_color: 'black')
      Piece.destroy_all
      expect(black_king.move_to!(queen_side_black_rook.row_coordinate, queen_side_black_rook.column_coordinate)).to eq 'castling'

      black_king.reload
      queen_side_black_rook.reload

      expect(black_king.column_coordinate).to eq 2
      expect(queen_side_black_rook.column_coordinate).to eq 3
    end

    it 'should return invalid if castling is possible' do
      game
      Piece.destroy_all
      black_king.update_attributes(has_moved?: true)
      expect(black_king.move_to!(queen_side_black_rook.row_coordinate, queen_side_black_rook.column_coordinate)).to eq 'invalid'
    end

    it 'should return invalid' do
      expect(@b_knight_2.move_to!(1, 4)).to eq 'invalid'
    end

    it 'should return captured' do
      expect(@w_bishop_1.move_to!(3, 2)).to eq 'captured'
      @b_pawn_3.reload
      expect(@b_pawn_3.row_coordinate).to eq nil
      expect(@b_pawn_3.column_coordinate).to eq nil
    end

    it 'should return moved' do
      expect(@w_rook_1.move_to!(7, 2)).to eq 'moved'
    end

    it 'should return invalid' do
      expect(@w_rook_1.move_to!(7, 3)).to eq 'invalid'
    end

    it 'should return moved' do
      @game.update_attributes(current_move_color: 'black')
      @game.reload
      expect(@b_rook_1.move_to!(4, 0)).to eq 'moved'
    end

    it 'should return captured' do
      @game.update_attributes(current_move_color: 'black')
      @game.reload
      expect(@b_rook_1.move_to!(5, 0)).to eq 'captured'
      @w_bishop_1.reload
      expect(@w_bishop_1.row_coordinate).to eq nil
      expect(@w_bishop_1.column_coordinate).to eq nil
    end

    context 'cannot move into check' do
      it 'should return invalid' do
        king = FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 3, column_coordinate: 4)
        FactoryGirl.create(:rook, color: 'black', game_id: game.id, row_coordinate: 1, column_coordinate: 3)
        FactoryGirl.create(:queen, color: 'black', game_id: game.id, row_coordinate: 2, column_coordinate: 6)

        expect(king.move_to!(2, 3)).to eq 'invalid'
        expect(king.move_to!(2, 4)).to eq 'invalid'
        expect(king.move_to!(2, 5)).to eq 'invalid'
        expect(king.move_to!(3, 3)).to eq 'invalid'
        expect(king.move_to!(3, 5)).to eq 'invalid'
        expect(king.move_to!(4, 3)).to eq 'invalid'
        expect(king.move_to!(4, 4)).to eq 'invalid'
        expect(king.move_to!(4, 5)).to eq 'moved'
      end
    end

  end

  describe 'obstructed? method' do
    it 'should return false' do
      expect(@w_bishop_1.obstructed?(3, 2)).to eq false
    end

    it 'should return true' do
      expect(@b_bishop_1.obstructed?(2, 3)).to eq true
    end

    it 'should return true' do
      expect(@b_rook_1.obstructed?(3, 0)).to eq true
    end

    it 'should return invalid' do
      expect(@w_knight_1.obstructed?(4, 1)).to eq 'invalid'
    end

    it 'should return false' do
      expect(@w_rook_1.obstructed?(5, 0)).to eq false
    end

    it 'should return false' do
      expect(@w_rook_1.obstructed?(7, 2)).to eq false
    end

    it 'should return false' do
      expect(@b_pawn_7.obstructed?(2, 7)).to eq false
    end

    it 'should return true' do
      expect(@w_rook_2.obstructed?(3, 7)).to eq true
    end

    it 'should return invalid' do
      expect(@w_rook_2.obstructed?(3, 5)).to eq 'invalid'
    end

    it 'should return false' do
      expect(@w_pawn_2.obstructed?(1, 7)).to eq false
    end

    it 'should return false' do
      expect(@w_rook_1.obstructed?(1, 6)).to eq false
    end

    it 'should return false' do
      expect(@b_knight_1.obstructed?(6, 7)).to eq false
    end

    it 'should return true' do
      expect(@w_pawn_1.obstructed?(2, 4)).to eq true
    end
  end
end
