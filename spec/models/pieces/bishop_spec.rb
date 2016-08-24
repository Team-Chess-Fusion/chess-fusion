require 'rails_helper'

RSpec.describe Bishop, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:bishop) { FactoryGirl.create(:bishop) }
  let(:white_bishop) { FactoryGirl.create(:bishop, color: 'white', row_coordinate: 0, column_coordinate: 2, game_id: game.id) }
  let(:black_pawn) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 7, color: 'black') }
  let(:black_rook) { FactoryGirl.create(:rook, color: 'black', row_coordinate: 7, column_coordinate: 7, game_id: game.id) }

  describe 'valid_move?' do
    it 'should return true when the bishop moves up diagonally' do
      expect(bishop.valid_move?(4, 4)).to eq true
      expect(bishop.valid_move?(1, 3)).to eq true
    end

    it 'should return true when the bishop down up diagonally' do
      expect(bishop.valid_move?(3, 1)).to eq true
      expect(bishop.valid_move?(0, 0)).to eq true
    end

    it 'should return false when the bishop moves within the same column' do
      expect(bishop.valid_move?(2, 6)).to eq false
      expect(bishop.valid_move?(2, 1)).to eq false
    end

    it 'should return false when the bishop moves within the same row' do
      expect(bishop.valid_move?(0, 2)).to eq false
      expect(bishop.valid_move?(6, 2)).to eq false
    end

    it 'should return false when the bishop moves up diagnonally but slope not 1' do
      expect(bishop.valid_move?(5, 4)).to eq false
      expect(bishop.valid_move?(1, 5)).to eq false
    end
    it 'should return false when the bishop moves down diagnonally but slope not 1' do
      expect(bishop.valid_move?(1, 0)).to eq false
      expect(bishop.valid_move?(5, 1)).to eq false
    end

    it 'should return false if destination is obstructed' do
      expect(white_bishop.valid_move?(1, 2)).to eq false
    end
    it 'should return false if destination is obstructed' do
      expect(white_bishop.valid_move?(1, 1)).to eq true
      expect(white_bishop.valid_move?(7, 7)).to eq false
    end
  end
end
