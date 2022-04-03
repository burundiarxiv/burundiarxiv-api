# frozen_string_literal: true

desc 'Compute score for all games where score is zero'
task compute_zero_score: :environment do
  games_with_score_at_zero = Game.where(score: 0)
  games_with_score_at_zero.each { |game| game.save! }
  puts "Before Task: #{games_with_score_at_zero.count}"
  puts "After Task: #{Game.where(score: 0).count}"
end

task recompute_score: :environment do
  games_with_old_score = Game.where('score > 0')
  games_with_old_score.each do |game|
    game.compute_score
    game.save!
  end
  puts "Before Task: #{games_with_old_score.count}"
  puts "After Task: #{Game.where('score > 100').count}"
end
