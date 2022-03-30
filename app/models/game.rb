# frozen_string_literal: true

class Game < ApplicationRecord
  def start_time
    read_attribute(:start_time).in_time_zone(timezone)
  end

  def end_time
    read_attribute(:end_time).in_time_zone(timezone)
  end
end
