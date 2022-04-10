# frozen_string_literal: true

class Meaning < ApplicationRecord
  validates :keyword, :meaning, :proverb, presence: true
end
