FactoryBot.define do
  factory :curura_game, class: "Curura::Game" do
    score { 15 }
    country { "MyString" }
    start_time { "2024-04-11 19:38:30" }
  end
end
