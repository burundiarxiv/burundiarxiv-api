# frozen_string_literal: true

json.count @count
json.meanings do
  json.array!(@meanings) do |proverb, meanings|
    json.proverb proverb
    json.keyword meanings.first.keyword
    json.meanings { json.array! meanings.map(&:meaning) }
  end
end
