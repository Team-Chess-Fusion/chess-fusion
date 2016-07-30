require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:user) {FactoryGirl.create(:user)}
  describe "initial test" do
    it "should be true" do
      expect(true).to eq true
    end
  end

  describe "available scope" do
    it "should return available games" do
      available_game = FactoryGirl.create(:game, white_player_id: user.id)
      expect(Game.available).to include available_game
    end
  end

end
