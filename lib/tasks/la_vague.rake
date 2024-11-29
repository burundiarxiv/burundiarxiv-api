require "watir"
require "dotenv"

namespace :la_vague do
  desc "Automates booking an Aquagym tonic session for two users"

  task :book do
    Dotenv.load

    # Helper to calculate the booking date and time
    def calculate_booking_date_and_time
      if ENV["BOOKING_DATE"] && ENV["BOOKING_HOUR"]
        [ENV["BOOKING_DATE"], ENV["BOOKING_HOUR"]]
      else
        # Default: Book for the next week's Tuesday at 12:15
        today = Date.today
        next_tuesday = today + ((2 - today.wday) % 7 + 7) # Find next Tuesday
        booking_tuesday = next_tuesday - 7 # Book the Tuesday before
        [booking_tuesday.strftime("%Y-%m-%d"), "12:15"]
      end
    end

    date, hour = calculate_booking_date_and_time

    # Helper to perform the booking for a user
    def book_for_user(browser, username, password, date, hour)
      browser.goto "https://member.resamania.com/equalia-lavagueCPS/"
      browser.button(value: "Log in").click
      sleep 10

      login_field = browser.text_field(id: "login_step_login_username")
      login_field.set username

      browser.button(value: "Fill in my password").click
      sleep 10

      password_field = browser.text_field(id: "_password")
      password_field.set password

      browser.button(value: "Log into my club").click
      sleep 10

      link =
        "https://member.resamania.com/equalia-lavagueCPS/planning?club=%2Fequalia%2Fclubs%2F1238&startedAt=#{date}"
      browser.goto link
      sleep 10

      browser.driver.manage.window.maximize
      sleep 10

      grid_divs = browser.divs(class: "MuiGrid-root")

      aquagym_tonic_card =
        grid_divs.find do |card|
          card.text.gsub(/\s+/, " ").match?(/Aquagym tonic.*#{hour}.*BOOK/i) && card.text.size < 200
        end
      raise "No available slots found!" unless aquagym_tonic_card

      button = aquagym_tonic_card.buttons.find { |btn| btn.text.match?(/BOOK/i) }
      button.click
    end

    # Booking for both users
    browser = Watir::Browser.new
    begin
      puts "Booking for User 1..."
      book_for_user(
        browser,
        ENV["LA_VAGUE_USERNAME_LIONEL"],
        ENV["LA_VAGUE_PASSWORD_LIONEL"],
        date,
        hour,
      )
      puts "Successfully booked for User 1."

      puts "Booking for User 2..."
      book_for_user(
        browser,
        ENV["LA_VAGUE_USERNAME_PARTNER"],
        ENV["LA_VAGUE_PASSWORD_PARTNER"],
        date,
        hour,
      )
      puts "Successfully booked for User 2."

      puts "Aquagym tonic session successfully booked for both users on #{date} at #{hour}."
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    ensure
      browser.close
    end
  end
end
