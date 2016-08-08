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
      white_player_id 1
      black_player_id 3
    end

    factory :single_player_game do
      white_player_id 1
    end
  end

  factory :piece do
    color 'black'
    type 'Rook'
    row_coordinate 0
    column_coordinate 0
    association :game
  end

  factory :knight do
    color 'black'
    type 'Knight'
    row_coordinate 4
    column_coordinate 3
    association :game
  end
end
