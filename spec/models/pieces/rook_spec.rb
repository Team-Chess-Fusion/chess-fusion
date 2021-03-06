require 'rails_helper'

RSpec.describe Rook, type: :model do
  let(:rook) { FactoryGirl.create(:rook) }

  describe 'valid_move?' do
    before do
      Game::BoardPopulator.new(rook.game).run
    end
    it 'should return true if destination is (row 2, col 3)' do
      expect(rook.valid_move?(2, 3)).to eq true
    end

    it 'should return true if destination is (row 2, col 7)' do
      expect(rook.valid_move?(2, 7)).to eq true
    end

    it 'should return false if destination is (row 0, col 5)(obstruction)' do
      expect(rook.valid_move?(0, 5)).to eq false
    end

    it 'should return false if destination is (row 7, col 5)(obstruction)' do
      expect(rook.valid_move?(7, 5)).to eq false
    end

    it 'should return false if destination is (row 3, col 4)' do
      expect(rook.valid_move?(3, 4)).to eq false
    end

    it 'should return false if destination is (row 1, col 4)' do
      expect(rook.valid_move?(1, 4)).to eq false
    end

    it 'should return false if destination is (row 3, col 6)' do
      expect(rook.valid_move?(3, 6)).to eq false
    end

    it 'should return false if destination is (row 1, col 6)' do
      expect(rook.valid_move?(1, 6)).to eq false
    end
  end
end
