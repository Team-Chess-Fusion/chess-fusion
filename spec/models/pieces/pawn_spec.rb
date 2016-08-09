require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe 'valid_move? for pawn method' do
    before do
      allow_any_instance_of(Game).to receive(:populate_board!).and_return true
    end

    let(:game) { FactoryGirl.create(:game) }
    let(:b_pawn) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 1, color: 'black') }
    let(:w_pawn) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 5, column_coordinate: 1, color: 'white') }
    let(:b_pawn_2) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 6, column_coordinate: 2, color: 'black') }
    let(:b_pawn_3) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 1, column_coordinate: 5, color: 'black') }
    let(:w_pawn_2) { FactoryGirl.create(:pawn, game_id: game.id, row_coordinate: 2, column_coordinate: 5, color: 'white') }

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

    it 'should return false' do
      expect(w_pawn_2.row_coordinate).to eq 2
      expect(w_pawn_2.column_coordinate).to eq 5
      expect(b_pawn_3.obstructed?(3, 5)).to eq true
      expect(b_pawn_3.valid_move?(3, 5)).to eq false
      expect(b_pawn_3.valid_move?(2, 5)).to eq false
    end
  end
end
