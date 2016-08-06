FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "DummyEmail#{n}@gmail.com"
    end
    password 'secretPassword'
    password_confirmation 'secretPassword'
  end

  factory :game do
    sequence :name do |n|
      "AwesomeChessGame#{n}"
    end
    factory :full_game do
      association :white_player, factory: :user
      association :black_player, factory: :user
    end

    factory :single_player_game do
      association :white_player, factory: :user
    end
  end

  factory :chess_piece do
    type 'Knight'
    color 'white'
    row_coordinate 0
    column_coordinate 0
    association :full_game
  end
end
