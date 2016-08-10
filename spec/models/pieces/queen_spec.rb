require 'rails_helper'

RSpec.describe Queen, type: :model do
  let(:queen) { FactoryGirl.create(:queen) }

  describe 'valid_move?' do
    it 'should return true if destination is (row 6, col 5)' do
      expect(queen.valid_move?(6, 5)).to eq true
    end

    it 'should return true if destination is (row 6, col 0)' do
      expect(queen.valid_move?(6, 0)).to eq true
    end

    it 'should return true if destination is (row 7, col 2)' do
      expect(queen.valid_move?(7, 2)).to eq true
    end

    it 'should return true if destination is (row 4, col 2)' do
      expect(queen.valid_move?(4, 2)).to eq true
    end

    it 'should return true if destination is (row 4, col 4)' do
      expect(queen.valid_move?(4, 4)).to eq true
    end

    it 'should return true if destination is (row 7, col 1)' do
      expect(queen.valid_move?(7, 1)).to eq true
    end

    it 'should return true if destination is (row 4, col 0)' do
      expect(queen.valid_move?(4, 0)).to eq true
    end

    it 'should return true if destination is (row 7, col 3)' do
      expect(queen.valid_move?(7, 3)).to eq true
    end

    it 'should return false if destination is (row 4, col 6)' do
      expect(queen.valid_move?(4, 6)).to eq false
    end

    it 'should return false if destination is (row 5, col 5)' do
      expect(queen.valid_move?(5, 5)).to eq false
    end

    it 'should return false if destination is (row 2, col 3)' do
      expect(queen.valid_move?(2, 3)).to eq false
    end

    it 'should return false if destination is (row 1, col 4)' do
      expect(queen.valid_move?(1, 4)).to eq false
    end
  end
end
