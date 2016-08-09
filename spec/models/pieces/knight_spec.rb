require 'rails_helper'

RSpec.describe Knight, type: :model do
  let(:knight) { FactoryGirl.create(:knight) }
  describe 'valid_move? method' do
    it 'should return true if destination is (row 2, col 2)' do
      expect(knight.valid_move?(2, 2)).to eq true
    end

    it 'should return true if destination is (row 2, col 4)' do
      expect(knight.valid_move?(2, 4)).to eq true
    end

    it 'should return true if destination is (row 3, col 1)' do
      expect(knight.valid_move?(3, 1)).to eq true
    end

    it 'should return true if destination is (row 5, col 1)' do
      expect(knight.valid_move?(5, 1)).to eq true
    end

    it 'should return true if destination is (row 6, col 2)' do
      expect(knight.valid_move?(6, 2)).to eq true
    end

    it 'should return true if destination is (row 6, col 4)' do
      expect(knight.valid_move?(6, 4)).to eq true
    end

    it 'should return true if destination is (row 5, col 5)' do
      expect(knight.valid_move?(5, 5)).to eq true
    end

    it 'should return true if destination is (row 3, col 5)' do
      expect(knight.valid_move?(3, 5)).to eq true
    end

    it 'should return false if destination is (row 1, col 1)' do
      expect(knight.valid_move?(1, 1)).to eq false
    end

    it 'should return false if destination is (row 2, col 3)' do
      expect(knight.valid_move?(2, 3)).to eq false
    end

    it 'should return false if destination is (row 7, col 2)' do
      expect(knight.valid_move?(7, 2)).to eq false
    end
  end
end
