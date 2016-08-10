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

  factory :piece do
    type 'Knight'
    color 'white'
    row_coordinate 0
    column_coordinate 0
    association :game, factory: :full_game
  end

  factory :knight do
    color 'black'
    type 'Knight'
    row_coordinate 4
    column_coordinate 3
    association :game
  end

  factory :pawn do
    color 'black'
    type 'Pawn'
    row_coordinate 1
    column_coordinate 1
    association :game
  end

  factory :king do
    color 'black'
    type 'King'
    row_coordinate 3
    column_coordinate 3
    association :game
  end
end
