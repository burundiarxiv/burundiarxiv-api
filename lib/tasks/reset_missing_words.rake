# frozen_string_literal: true

desc 'Reset missing words'
task reset_missing_words: :environment do
  MissingWord.destroy_all
end