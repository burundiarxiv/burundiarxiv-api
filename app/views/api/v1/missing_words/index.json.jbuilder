# frozen_string_literal: true

# { 'count' => @count, 'missing_words' => @json.array! @missing_words, :value, :count }.to_json
# json.call @count, json.array! @missing_words, :value, :count
# json.count @count
# json.array! @missing_words, :value, :count
json.count @count
json.missing_words @missing_words, :value, :count
