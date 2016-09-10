require 'rails_helper'

RSpec.describe Game::BoardPopulator do
  let(:game) { FactoryGirl.create(:game) }

  describe '#run' do
    context 'before run method is executed' do
      it 'should return true' do
        populator = Game::BoardPopulator.new(game)
        expect { populator.run }.to change { game.pieces.count }.by 32
      end
    end
    context 'after run method is executed' do
      before do
        Game::BoardPopulator.new(game).run
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
      it 'sets white to move first' do
        expect(game.current_move_color).to eq 'white'
      end
    end
  end
end
