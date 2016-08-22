require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game) }
  let(:full_game) { FactoryGirl.create(:full_game) }
  let(:single_player_game) { FactoryGirl.create(:single_player_game) }

  describe '#checkmate? method' do
    let!(:game2) { FactoryGirl.create(:game) }

    it 'should return true' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 4, column_coordinate: 7, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 4, column_coordinate: 5, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 0, column_coordinate: 7, color: 'white')
      expect(game2.checkmate?).to eq true
    end

    it 'should return true' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 5, column_coordinate: 0, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 5, column_coordinate: 2, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 5, column_coordinate: 1, color: 'white')
      expect(game2.checkmate?).to eq true
    end

    it 'should return false - black rook can block check' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 5, column_coordinate: 0, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 7, column_coordinate: 5, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 5, column_coordinate: 4, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 0, column_coordinate: 2, color: 'black')
      expect(game2.checkmate?).to eq false
    end

    it 'should return false - black rook can capture white queen' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 5, column_coordinate: 0, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 7, column_coordinate: 5, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 5, column_coordinate: 4, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 0, column_coordinate: 4, color: 'black')
      expect(game2.checkmate?).to eq false
    end

    it 'should return false - black king is not in check' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 6, column_coordinate: 0, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 7, column_coordinate: 5, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 5, column_coordinate: 4, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 0, column_coordinate: 2, color: 'black')
      expect(game2.checkmate?).to eq false
    end

    it 'should return false - black knight can block check from white bishop' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 3, column_coordinate: 4, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 7, column_coordinate: 7, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 7, column_coordinate: 3, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 7, column_coordinate: 5, color: 'white')
      FactoryGirl.create(:knight, game: game2, row_coordinate: 3, column_coordinate: 7, color: 'black')
      FactoryGirl.create(:bishop, game: game2, row_coordinate: 0, column_coordinate: 7, color: 'white')
      expect(game2.checkmate?).to eq false
    end

    it 'should return true' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 3, column_coordinate: 4, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 7, column_coordinate: 7, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 7, column_coordinate: 3, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 7, column_coordinate: 5, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 0, column_coordinate: 4, color: 'white')
      FactoryGirl.create(:knight, game: game2, row_coordinate: 3, column_coordinate: 7, color: 'black')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 3, column_coordinate: 0, color: 'black')
      expect(game2.checkmate?).to eq true
    end

    it 'should return false - black rook can capture attacking white rook' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 3, column_coordinate: 4, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 7, column_coordinate: 7, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 7, column_coordinate: 3, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 7, column_coordinate: 5, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 0, column_coordinate: 4, color: 'white')
      FactoryGirl.create(:knight, game: game2, row_coordinate: 3, column_coordinate: 7, color: 'black')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 0, column_coordinate: 0, color: 'black')
      expect(game2.checkmate?).to eq false
    end

    it 'should return true' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 3, column_coordinate: 0, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 7, column_coordinate: 7, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 7, column_coordinate: 0, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 7, column_coordinate: 1, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 0, column_coordinate: 0, color: 'black')
      FactoryGirl.create(:knight, game: game2, row_coordinate: 2, column_coordinate: 2, color: 'black')
      FactoryGirl.create(:bishop, game: game2, row_coordinate: 0, column_coordinate: 3, color: 'white')
      expect(game2.checkmate?).to eq true
    end

    it 'should return false - black rook can block diagonal attack from white bishop' do
      FactoryGirl.create(:king, game: game2, row_coordinate: 3, column_coordinate: 0, color: 'black')
      FactoryGirl.create(:king, game: game2, row_coordinate: 7, column_coordinate: 7, color: 'white')
      FactoryGirl.create(:queen, game: game2, row_coordinate: 0, column_coordinate: 1, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 7, column_coordinate: 1, color: 'black')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 4, column_coordinate: 7, color: 'white')
      FactoryGirl.create(:rook, game: game2, row_coordinate: 2, column_coordinate: 7, color: 'white')
      FactoryGirl.create(:bishop, game: game2, row_coordinate: 7, column_coordinate: 4, color: 'white')
      expect(game2.checkmate?).to eq false
    end
  end

  describe 'determine_check method' do
    before do
      allow_any_instance_of(Game).to receive(:populate_board!).and_return true
      @white_king = FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 0, column_coordinate: 4)
      @black_king = FactoryGirl.create(:king, color: 'black', game_id: game.id, row_coordinate: 7, column_coordinate: 4)
    end
    context 'white king is being checked' do
      it 'should return true if black knight can capture king' do
        FactoryGirl.create(:knight, color: 'black', game_id: game.id, row_coordinate: 2, column_coordinate: 3)
        expect(game.in_check?).to eq @white_king
      end

      it 'should return true if black rook can capture king' do
        FactoryGirl.create(:rook, color: 'black', game_id: game.id, row_coordinate: 0, column_coordinate: 2)
        expect(game.in_check?).to eq @white_king
      end

      it 'should return true black queen can capture king' do
        FactoryGirl.create(:queen, color: 'black', game_id: game.id, row_coordinate: 3, column_coordinate: 1)
        expect(game.in_check?).to eq @white_king
      end
    end

    context 'white king is not checked' do
      it 'should return false if black pawn is out of range' do
        FactoryGirl.create(:pawn, game_id: game.id)
        expect(game.in_check?).to eq nil
      end
      it 'should return false if rook is blocked' do
        FactoryGirl.create(:rook, game_id: game.id, row_coordinate: 0, column_coordinate: 1)
        FactoryGirl.create(:knight, game_id: game.id, row_coordinate: 0, column_coordinate: 2)
        expect(game.in_check?).to eq nil
      end
      it 'should return false if kings are out of range' do
        expect(game.in_check?).to eq nil
      end
    end

    context 'black king is checked' do
      it 'should return true if white knight can capture king' do
        FactoryGirl.create(:knight, color: 'white', game_id: game.id, row_coordinate: 5, column_coordinate: 5)
        expect(game.in_check?).to eq @black_king
      end
      it 'should return true if white pawn can capture king' do
        FactoryGirl.create(:pawn, color: 'white', game_id: game.id, row_coordinate: 6, column_coordinate: 3)
        expect(game.in_check?).to eq @black_king
      end
      it 'should return true if white rook can capture king' do
        FactoryGirl.create(:rook, color: 'white', game_id: game.id, row_coordinate: 1, column_coordinate: 4)
        expect(game.in_check?).to eq @black_king
      end
    end

    context 'black king is not checked' do
      it 'should return false if white queen is blocked' do
        FactoryGirl.create(:queen, color: 'white', game_id: game.id, row_coordinate: 4, column_coordinate: 1)
        FactoryGirl.create(:knight, game_id: game.id, row_coordinate: 5, column_coordinate: 2)
        expect(game.in_check?).to eq nil
      end
      it 'should return false if rook is out of range' do
        FactoryGirl.create(:rook, color: 'white', game_id: game.id, row_coordinate: 6, column_coordinate: 1)
        expect(game.in_check?).to eq nil
      end
    end
  end

  describe 'stalemate?' do
    it 'should return false at start of game' do
      game.populate_board!
      expect(game.stalemate?('white')).to eq false
      expect(game.stalemate?('black')).to eq false
    end

    it 'should return true, no moves for white king' do
      FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 3, column_coordinate: 4)
      FactoryGirl.create(:rook, color: 'black', game_id: game.id, row_coordinate: 4, column_coordinate: 2)
      FactoryGirl.create(:rook, color: 'black', game_id: game.id, row_coordinate: 1, column_coordinate: 3)
      FactoryGirl.create(:queen, color: 'black', game_id: game.id, row_coordinate: 2, column_coordinate: 6)
      expect(game.stalemate?('white')).to eq true
    end

    it 'should return false, moves open for white king' do
      FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 3, column_coordinate: 4)
      FactoryGirl.create(:rook, color: 'black', game_id: game.id, row_coordinate: 4, column_coordinate: 2)
      FactoryGirl.create(:queen, color: 'black', game_id: game.id, row_coordinate: 2, column_coordinate: 6)
      expect(game.stalemate?('white')).to eq false
    end

    it 'should return true, no moves for white king' do
      FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 7, column_coordinate: 0)
      FactoryGirl.create(:rook, color: 'black', game_id: game.id, row_coordinate: 6, column_coordinate: 1)
      FactoryGirl.create(:queen, color: 'black', game_id: game.id, row_coordinate: 5, column_coordinate: 2)
      expect(game.stalemate?('white')).to eq true
    end

    it 'should return true, no moves for white king' do
      FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 0, column_coordinate: 0)
      FactoryGirl.create(:pawn, color: 'black', game_id: game.id, row_coordinate: 1, column_coordinate: 0)
      FactoryGirl.create(:queen, color: 'black', game_id: game.id, row_coordinate: 1, column_coordinate: 2)
      expect(game.stalemate?('white')).to eq true
    end

    it 'should return true, no moves for black king' do
      FactoryGirl.create(:king, color: 'black', game_id: game.id, row_coordinate: 0, column_coordinate: 5)
      FactoryGirl.create(:pawn, color: 'white', game_id: game.id, row_coordinate: 1, column_coordinate: 5)
      FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 2, column_coordinate: 5)
      expect(game.stalemate?('black')).to eq true
    end

    it 'should return true, no legal moves for black' do
      FactoryGirl.create(:king, color: 'black', game_id: game.id, row_coordinate: 0, column_coordinate: 0)
      FactoryGirl.create(:bishop, color: 'black', game_id: game.id, row_coordinate: 0, column_coordinate: 1)
      FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 2, column_coordinate: 1)
      FactoryGirl.create(:rook, color: 'white', game_id: game.id, row_coordinate: 0, column_coordinate: 4)
      expect(game.stalemate?('black')).to eq true
    end

    it 'should return false, legal moves open for black pieces' do
      FactoryGirl.create(:king, color: 'black', game_id: game.id, row_coordinate: 0, column_coordinate: 0)
      FactoryGirl.create(:bishop, color: 'black', game_id: game.id, row_coordinate: 0, column_coordinate: 1)
      FactoryGirl.create(:knight, color: 'black', game_id: game.id, row_coordinate: 5, column_coordinate: 5)
      FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 2, column_coordinate: 1)
      FactoryGirl.create(:rook, color: 'white', game_id: game.id, row_coordinate: 0, column_coordinate: 4)
      expect(game.stalemate?('black')).to eq false
    end

    it 'should return true, no legal moves for black' do
      FactoryGirl.create(:king, color: 'black', game_id: game.id, row_coordinate: 3, column_coordinate: 4)
      FactoryGirl.create(:bishop, color: 'black', game_id: game.id, row_coordinate: 4, column_coordinate: 4)
      FactoryGirl.create(:rook, color: 'black', game_id: game.id, row_coordinate: 4, column_coordinate: 3)

      FactoryGirl.create(:bishop, color: 'white', game_id: game.id, row_coordinate: 3, column_coordinate: 6)
      FactoryGirl.create(:bishop, color: 'white', game_id: game.id, row_coordinate: 5, column_coordinate: 2)
      FactoryGirl.create(:rook, color: 'white', game_id: game.id, row_coordinate: 1, column_coordinate: 3)
      FactoryGirl.create(:knight, color: 'white', game_id: game.id, row_coordinate: 1, column_coordinate: 6)
      FactoryGirl.create(:pawn, color: 'white', game_id: game.id, row_coordinate: 4, column_coordinate: 6)
      FactoryGirl.create(:queen, color: 'white', game_id: game.id, row_coordinate: 6, column_coordinate: 4)
      FactoryGirl.create(:king, color: 'white', game_id: game.id, row_coordinate: 7, column_coordinate: 4)
      expect(game.stalemate?('black')).to eq true
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
  end

  describe '#forfeiting_user' do
    it 'should allow the white player to forfeit' do
      game = full_game
      expect(game.forfeit).to eq(false)
      expect(game.active).to eq(true)
      game.forfeiting_user(game.white_player)
      expect(game.forfeit).to eq(true)
      expect(game.active).to eq(false)
      expect(game.winner_id).to eq(game.black_player_id)
    end
    it 'should allow the black player to forfeit' do
      game = full_game
      expect(game.forfeit).to eq(false)
      expect(game.active).to eq(true)
      game.forfeiting_user(game.black_player)
      expect(game.forfeit).to eq(true)
      expect(game.active).to eq(false)
      expect(game.winner_id).to eq(game.white_player_id)
    end
  end
end
