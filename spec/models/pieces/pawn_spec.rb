require 'rails_helper'

RSpec.describe Pawn, type: :model do
  let(:b_pawn) { FactoryGirl.create(:pawn, row_coordinate: 1, column_coordinate: 1, color: 'black') }
  let(:w_pawn) { FactoryGirl.create(:pawn, row_coordinate: 5, column_coordinate: 1, color: 'white') }
  let(:b_pawn_2) { FactoryGirl.create(:pawn, row_coordinate: 6, column_coordinate: 2, color: 'black')}

  describe 'valid_move? for pawn method' do
    it 'should return true' do
      expect(b_pawn.valid_move?(3, 1)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(2, 1)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(2, 2)).to eq true
    end

    it 'should return true' do
      expect(b_pawn.valid_move?(2, 0)).to eq true
    end

    it 'should return false' do
      expect(b_pawn.valid_move?(4, 1)).to eq false
    end

    it 'should return false' do
      expect(b_pawn.valid_move?(2, 3)).to eq false
    end

    it 'should return false' do
      expect(w_pawn.valid_move?(3, 1)).to eq false
    end

    it 'should return true' do
      expect(w_pawn.valid_move?(4, 1)).to eq true
    end

    it 'should return false' do
      expect(b_pawn_2.valid_move?(4, 2)).to eq false
    end
  end
end
