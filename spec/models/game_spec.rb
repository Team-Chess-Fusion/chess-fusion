require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game) }
  let(:full_game) { FactoryGirl.create(:full_game) }
  let(:single_player_game) { FactoryGirl.create(:single_player_game) }
  describe 'initial test' do
    it 'should be true' do
      expect(true).to eq true
    end
  end

  describe 'available scope' do
    before do
      Game.destroy_all
    end
    it 'should return available games' do
      available_game = FactoryGirl.create(:game, white_player_id: user.id)
      expect(Game.available).to include available_game
    end

    it 'should return no games if all games are full' do
      full_game
      expect(Game.available).to be_empty
    end

    it 'should return no games if no games have been created' do
      expect(Game.available).to be_empty
    end
  end
end
