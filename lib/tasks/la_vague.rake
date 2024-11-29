require "watir"
require "dotenv"

namespace :la_vague do
  desc "Automates booking an Aquagym tonic session for two users"

  task :book do
    Dotenv.load

    current_time = Time.now

    # unless current_time.wday == 2
    #   puts "The script only runs on Tuesday. Exiting."
    #   exit
    # end

    # Calculate the target booking date (Tuesday of next week)
    def calculate_booking_date
      today = Date.today
      today + 7 # Always book for the next Tuesday
    end

    def course
      ENV["COURSE"] || "Aquagym tonic"
    end

    def booking_hour
      ENV["BOOKING_HOUR"] || "12:15"
    end

    def booking_date
      ENV["BOOKING_DATE"] || calculate_booking_date.strftime("%Y-%m-%d")
    end

    def book_for_user(username, password)
      browser = Watir::Browser.new
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
        "https://member.resamania.com/equalia-lavagueCPS/planning?club=%2Fequalia%2Fclubs%2F1238&startedAt=#{booking_date}"
      browser.goto link
      sleep 10

      # Maximize the window of the page
      browser.driver.manage.window.maximize
      sleep 10

      grid_divs = browser.divs(class: "MuiGrid-root")

      # course = "Aquagym tonic"
      course = "Aqua prénatal"

      aquagym_tonic_card =
        grid_divs.find do |card|
          card.text.gsub(/\s+/, " ").match?(/#{course}.*#{booking_hour}.*BOOK/i) &&
            card.text.size < 200
        end
      raise "No available slots found!" unless aquagym_tonic_card

      button = aquagym_tonic_card.buttons.find { |btn| btn.text.match?(/BOOK/i) }
      button.click if button
      sleep 10
      browser.close
    end

    # Booking for both users
    begin
      puts "Booking for User 1..."
      book_for_user(ENV["LA_VAGUE_USERNAME_LIONEL"], ENV["LA_VAGUE_PASSWORD_LIONEL"])
      puts "Successfully booked for User 1."

      sleep 10

      puts "Booking for User 2..."

      book_for_user(ENV["LA_VAGUE_USERNAME_ANNAMARIA"], ENV["LA_VAGUE_PASSWORD_ANNAMARIA"])
      puts "Successfully booked for User 2."

      puts "#{course} session successfully booked for both users on #{booking_date} at #{booking_hour}."
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end
end
