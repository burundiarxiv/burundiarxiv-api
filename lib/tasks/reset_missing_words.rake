# frozen_string_literal: true

desc 'Reset missing words'
task reset_missing_words: :environment do
  before = MissingWord.count
  MissingWord.destroy_all
  puts "Before MissingWord: #{before}"
  puts "After MissingWord: #{MissingWord.count}"
end
