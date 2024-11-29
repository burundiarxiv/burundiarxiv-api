require "watir"
require "dotenv"

namespace :la_vague do
  desc "Automates booking an Aquagym tonic session"

  task :book do
    Dotenv.load

    date = ENV["BOOKING_DATE"] || "2024-11-27" # Default to specified date
    hour = ENV["BOOKING_HOUR"] || "20:15" # Default to specified hour

    browser = Watir::Browser.new

    begin
      browser.goto "https://member.resamania.com/equalia-lavagueCPS/"
      browser.button(value: "Log in").click
      sleep 10

      login_field = browser.text_field(id: "login_step_login_username")
      login_field.set ENV["LA_VAGUE_USERNAME_LIONEL"]

      browser.button(value: "Fill in my password").click
      sleep 10

      password_field = browser.text_field(id: "_password")
      password_field.set ENV["LA_VAGUE_PASSWORD_LIONEL"]

      browser.button(value: "Log into my club").click
      sleep 10

      link =
        "https://member.resamania.com/equalia-lavagueCPS/planning?club=%2Fequalia%2Fclubs%2F1238&startedAt=#{date}"
      browser.goto link
      sleep 10

      # maximize the window of the page
      browser.driver.manage.window.maximize
      sleep 10

      grid_divs = browser.divs(class: "MuiGrid-root")

      aquagym_tonic_card =
        grid_divs.find do |card|
          card.text.gsub(/\s+/, " ").match?(/Aquagym tonic.*#{hour}.*BOOK/i) && card.text.size < 200
        end
      button = aquagym_tonic_card.buttons.find { |button| button.text.match?(/BOOK/i) }
      button.click

      puts "Aquagym tonic session successfully booked for #{date} at #{hour}."
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    ensure
      browser.close
    end
  end
end
