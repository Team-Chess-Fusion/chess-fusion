require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game) }
  let(:full_game) { FactoryGirl.create(:full_game) }
  let(:single_player_game) { FactoryGirl.create(:single_player_game) }

  describe 'determine_check method' do
    before do
      allow_any_instance_of(Game).to receive(:populate_board!).and_return true
      @white_king = FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 7, column_coordinate: 4)
      @black_king = FactoryGirl.create(:king, color: 'black', game_id: game.id, row_coordinate: 0, column_coordinate: 4)
    end
    context 'white king is being checked' do
      it 'should return true if black knight can capture king' do
        FactoryGirl.create(:knight, color: 'black', game_id: game.id, row_coordinate: 5, column_coordinate: 3)
        expect(game.in_check?).to eq @white_king
      end

      it 'should return true if black rook can capture king' do
        FactoryGirl.create(:rook, color: 'black', game_id: game.id, row_coordinate: 7, column_coordinate: 2)
        expect(game.in_check?).to eq @white_king
      end

      it 'should return true black queen can capture king' do
        FactoryGirl.create(:queen, color: 'black', game_id: game.id, row_coordinate: 4, column_coordinate: 1)
        expect(game.in_check?).to eq @white_king
      end
    end

    context 'white king is not checked' do
      it 'should return false if black pawn is out of range' do
        FactoryGirl.create(:pawn, game_id: game.id)
        expect(game.in_check?).to eq nil
      end
      it 'should return false if rook is blocked' do
        FactoryGirl.create(:rook, game_id: game.id, row_coordinate: 7, column_coordinate: 1)
        FactoryGirl.create(:knight, game_id: game.id, row_coordinate: 7, column_coordinate: 2)
        expect(game.in_check?).to eq nil
      end
      it 'should return false if kings are out of range' do
        expect(game.in_check?).to eq nil
      end
    end

    context 'black king is checked' do
      it 'should return true if white knight can capture king' do
        FactoryGirl.create(:knight, color: 'white', game_id: game.id, row_coordinate: 2, column_coordinate: 5)
        expect(game.in_check?).to eq @black_king
      end
      it 'should return true if white pawn can capture king' do
        FactoryGirl.create(:pawn, color: 'white', game_id: game.id, row_coordinate: 1, column_coordinate: 3)
        expect(game.in_check?).to eq @black_king
      end
      it 'should return true if white rook can capture king' do
        FactoryGirl.create(:rook, color: 'white', game_id: game.id, row_coordinate: 6, column_coordinate: 4)
        expect(game.in_check?).to eq @black_king
      end
    end

    context 'black king is not checked' do
      it 'should return false if white queen is blocked' do
        FactoryGirl.create(:queen, color: 'white', game_id: game.id, row_coordinate: 3, column_coordinate: 1)
        FactoryGirl.create(:knight, game_id: game.id, row_coordinate: 2, column_coordinate: 2)
        expect(game.in_check?).to eq nil
      end
      it 'should return false if rook is out of range' do
        FactoryGirl.create(:rook, color: 'white', game_id: game.id, row_coordinate: 1, column_coordinate: 1)
        expect(game.in_check?).to eq nil
      end
    end
  end

  describe 'available scope' do
    before do
      Game.destroy_all
      User.destroy_all
    end
    it 'should return available games' do
      available_game = FactoryGirl.create(:game, white_player_id: user.id)
      expect(Game.available).to include available_game
    end

    it 'should return no games if all games are full' do
      full_game
      expect(Game.available).to be_empty
    end

    it 'should return no games if no games have been created' do
      expect(Game.available).to be_empty
    end
  end

  describe 'populate board!' do
    before do
      game.populate_board!
    end
    it 'should have a white knight located at row 0 column 1' do
      expect(game.pieces.where(type: 'Knight', color: 'white').first.row_coordinate).to eq(0)
      expect(game.pieces.where(type: 'Knight', color: 'white').first.column_coordinate).to eq(1)
    end
    it 'should have the white king located at row 0 column 4' do
      expect(game.pieces.where(type: 'King', color: 'white').first.row_coordinate).to eq(0)
      expect(game.pieces.where(type: 'King', color: 'white').first.column_coordinate).to eq(4)
    end
    it 'should have a black knight located at row 7 column 1' do
      expect(game.pieces.where(type: 'Knight', color: 'black').first.row_coordinate).to eq(7)
      expect(game.pieces.where(type: 'Knight', color: 'black').first.column_coordinate).to eq(1)
    end
    it 'should have the black king located at row 7 column 4' do
      expect(game.pieces.where(type: 'King', color: 'black').first.row_coordinate).to eq(7)
      expect(game.pieces.where(type: 'King', color: 'black').first.column_coordinate).to eq(4)
    end
    it 'the game should have 32 pieces' do
      expect(game.pieces.count).to eq(32)
    end
    it 'sets white to move first' do
      expect(game.move_turn).to eq 'white'
    end
  end
end
