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
  end
    
end