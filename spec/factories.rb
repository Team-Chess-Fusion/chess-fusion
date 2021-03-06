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
    color 'white'
    type 'Pawn'
    row_coordinate 1
    column_coordinate 1
    association :game

    factory :en_passant_pawn do
      en_passant nil
    end
  end

  factory :king do
    color 'black'
    type 'King'
    row_coordinate 3
    column_coordinate 3
    association :game

    factory :moved_king do
      has_moved true
    end
  end

  factory :rook do
    color 'black'
    type 'Rook'
    row_coordinate 2
    column_coordinate 5
    association :game

    factory :moved_rook do
      has_moved true
    end
  end

  factory :queen do
    color 'black'
    type 'Queen'
    row_coordinate 3
    column_coordinate 4
    association :game
  end

  factory :bishop do
    color 'black'
    type 'Bishop'
    row_coordinate 2
    column_coordinate 2
    association :game
  end
end
