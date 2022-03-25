# frozen_string_literal: true

FactoryBot.define do
  factory :missing_word do
    value { 'test' }
    count { 1 }
  end
end
