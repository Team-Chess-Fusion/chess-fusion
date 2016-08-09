require 'rails_helper'

RSpec.describe Rook, type: :model do
  let(:rook) { FactoryGirl.create(:rook) }

  describe 'valid_move?' do
    it 'should return true if destination is (row 2, col 3)' do
      expect(rook.valid_move?(2, 3)).to eq true
    end

    it 'should return true if destination is (row 2, col 7)' do
      expect(rook.valid_move?(2, 7)).to eq true
    end

    it 'should return true if destination is (row 0, col 5)' do
      expect(rook.valid_move?(0, 5)).to eq true
    end

    it 'should return true if destination is (row 6, col 5)' do
      expect(rook.valid_move?(6, 5)).to eq true
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
