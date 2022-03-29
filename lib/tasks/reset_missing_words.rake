# frozen_string_literal: true

desc 'Reset missing words'
task reset_missing_words: :environment do
  puts "count MissingWord: #{MissingWord.count}"
  puts 'destroying'
  MissingWord.destroy_all
  puts "count MissingWord: #{MissingWord.count}"
end
