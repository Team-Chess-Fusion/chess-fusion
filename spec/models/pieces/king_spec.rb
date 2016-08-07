require 'rails_helper'

RSpec.describe King, type: :model do
  before :all do
    @game = FactoryGirl.create(:game)
    Piece.destroy_all
    @king = FactoryGirl.create(:king)
  end

  describe 'valid_move?' do
    it 'should return true when the king moves up or down one row' do
      expect(@king.valid_move?(4, 3)).to eq true
      expect(@king.valid_move?(2, 3)).to eq true
    end

    it 'should return true when the king moves left or right one column' do
      expect(@king.valid_move?(3, 2)).to eq true
      expect(@king.valid_move?(3, 4)).to eq true
    end

    it 'should return true when the king moves diagonally' do
      expect(@king.valid_move?(4, 2)).to eq true
      expect(@king.valid_move?(4, 4)).to eq true
      expect(@king.valid_move?(2, 2)).to eq true
      expect(@king.valid_move?(2, 4)).to eq true
    end

    it 'should return false when the king moves up or down more than one row' do
      expect(@king.valid_move?(6, 3)).to eq false
      expect(@king.valid_move?(1, 3)).to eq false
    end

    it 'should return false when the king moves left or right more than one column' do
      expect(@king.valid_move?(3, 1)).to eq false
      expect(@king.valid_move?(3, 6)).to eq false
    end

    it 'should return false when the king moves more than one row/column diagonally' do
      expect(@king.valid_move?(5, 2)).to eq false
      expect(@king.valid_move?(5, 4)).to eq false
      expect(@king.valid_move?(1, 2)).to eq false
      expect(@king.valid_move?(1, 4)).to eq false
    end
  end
end
