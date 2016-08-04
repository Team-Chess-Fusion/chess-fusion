require 'rails_helper'

RSpec.describe Piece, type: :model do
  before :all do
    Game.destroy_all
    @game = FactoryGirl.create(:game)
    Piece.destroy_all
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

    it 'should return error' do
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
  end
end
