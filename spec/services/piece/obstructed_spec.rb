require 'rails_helper'

RSpec.describe Piece::Obstructed do
  let(:game) { FactoryGirl.create(:game) }

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

  describe 'obstructed? method' do
    it 'should return false' do
      obstructed_check = Piece::Obstructed.new(@w_bishop_1, 3, 2)
      expect(obstructed_check.run).to eq false
    end

    it 'should return true' do
      obstructed_check = Piece::Obstructed.new(@b_bishop_1, 2, 3)
      expect(obstructed_check.run).to eq true
    end

    it 'should return true' do
      obstructed_check = Piece::Obstructed.new(@b_rook_1, 3, 0)
      expect(obstructed_check.run).to eq true
    end

    it 'should return invalid' do
      obstructed_check = Piece::Obstructed.new(@w_knight_1, 4, 1)
      expect(obstructed_check.run).to eq 'invalid move'
    end

    it 'should return false' do
      obstructed_check = Piece::Obstructed.new(@w_rook_1, 5, 0)
      expect(obstructed_check.run).to eq false
    end

    it 'should return false' do
      obstructed_check = Piece::Obstructed.new(@w_rook_1, 7, 2)
      expect(obstructed_check.run).to eq false
    end

    it 'should return false' do
      obstructed_check = Piece::Obstructed.new(@b_pawn_7, 2, 7)
      expect(obstructed_check.run).to eq false
    end

    it 'should return true' do
      obstructed_check = Piece::Obstructed.new(@w_rook_2, 3, 7)
      expect(obstructed_check.run).to eq true
    end

    it 'should return invalid' do
      obstructed_check = Piece::Obstructed.new(@w_rook_2, 3, 5)
      expect(obstructed_check.run).to eq 'invalid move'
    end

    it 'should return false' do
      obstructed_check = Piece::Obstructed.new(@w_pawn_2, 1, 7)
      expect(obstructed_check.run).to eq false
    end

    it 'should return false' do
      obstructed_check = Piece::Obstructed.new(@w_rook_1, 1, 6)
      expect(obstructed_check.run).to eq false
    end

    it 'should return false' do
      obstructed_check = Piece::Obstructed.new(@b_knight_1, 6, 7)
      expect(obstructed_check.run).to eq false
    end

    it 'should return true' do
      obstructed_check = Piece::Obstructed.new(@w_pawn_1, 2, 4)
      expect(obstructed_check.run).to eq true
    end
  end
end
