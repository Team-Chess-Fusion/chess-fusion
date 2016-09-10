require 'rails_helper'

RSpec.describe Queen, type: :model do
  let(:queen) { FactoryGirl.create(:queen) }

  describe 'valid_move?' do
    before do
      Game::BoardPopulator.new(queen.game).run
    end
    it 'should return true if destination is (row 1, col 6)' do
      expect(queen.valid_move?(1, 6)).to eq true
    end

    it 'should return false if destination is (row 0, col 7)(obstruction)' do
      expect(queen.valid_move?(0, 7)).to eq false
    end

    it 'should return true if destination is (row 5, col 2)' do
      expect(queen.valid_move?(5, 2)).to eq true
    end

    it 'should return false if destination is (row 7, col 0)(obstruction)' do
      expect(queen.valid_move?(7, 0)).to eq false
    end

    it 'should return true if destination is (row 3, col 7)' do
      expect(queen.valid_move?(3, 7)).to eq true
    end

    it 'should return true if destination is (row 3, col 0)' do
      expect(queen.valid_move?(3, 0)).to eq true
    end

    it 'should return true if destination is (row 1, col 4)' do
      expect(queen.valid_move?(1, 4)).to eq true
    end

    it 'should return false if destination is (row 0, col 5)(obstruction)' do
      expect(queen.valid_move?(0, 5)).to eq false
    end

    it 'should return true if destination is (row 6, col 4)' do
      expect(queen.valid_move?(6, 4)).to eq true
    end

    it 'should return false if destination is (row 7, col 4)(obstruction)' do
      expect(queen.valid_move?(7, 4)).to eq false
    end

    it 'should return false if destination is (row 5, col 5)' do
      expect(queen.valid_move?(5, 5)).to eq false
    end

    it 'should return false if destination is (row 4, col 1)' do
      expect(queen.valid_move?(4, 1)).to eq false
    end
  end
end
