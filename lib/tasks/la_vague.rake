require "watir"
require "dotenv"

namespace :la_vague do
  desc "Automates booking an Aquagym tonic session for two users"

  task :book do
    Dotenv.load

    current_time = Time.now

    unless current_time.wday == 2
      puts "The script only runs on Tuesday. Exiting."
      exit
    end

    # Calculate the target booking date (next week)
    def calculate_booking_date
      today = Date.today
      today + 7 # Always book for the next week
    end

    def course
      ENV["COURSE"] || "Aquagym tonic mardi matin"
    end

    def booking_hour
      ENV["BOOKING_HOUR"] || "12:15"
    end

    def booking_date
      ENV["BOOKING_DATE"] || calculate_booking_date.strftime("%Y-%m-%d")
    end

    def headless_mode
      ENV["HEADLESS"] == "true" || ENV["DYNO"] # Heroku sets DYNO environment variable
    end

    def on_heroku?
      ENV["DYNO"].present?
    end

    def create_browser
      args = %w[
        --no-sandbox
        --disable-dev-shm-usage
        --disable-gpu
        --window-size=1920,1080
        --disable-web-security
        --disable-features=VizDisplayCompositor
      ]

      if headless_mode
        args += %w[--headless=new --disable-extensions --disable-plugins --disable-images]
      end

      Watir::Browser.new(:chrome, options: { args: args })
    end

    def book_for_user(username, password)
      browser = create_browser

      begin
        puts "Starting browser session for user: #{username}"
        browser.goto "https://member.resamania.com/equalia-lavagueCPS/"

        # Wait for login button and click
        browser.wait_until(timeout: 30) { browser.button(value: "Log in").present? }
        browser.button(value: "Log in").click
        sleep 10
        puts "Clicked on Log in"

        # Fill username
        browser.wait_until(timeout: 30) do
          browser.text_field(id: "login_step_login_username").present?
        end
        login_field = browser.text_field(id: "login_step_login_username")
        login_field.set username

        browser.button(value: "Fill in my password").click
        sleep 10
        puts "Clicked on Fill in my password"

        # Fill password
        browser.wait_until(timeout: 30) { browser.text_field(id: "_password").present? }
        password_field = browser.text_field(id: "_password")
        password_field.set password

        browser.button(value: "Log into my club").click
        sleep 10
        puts "Clicked on Log into my club"

        link =
          "https://member.resamania.com/equalia-lavagueCPS/planning?club=%2Fequalia%2Fclubs%2F1238&startedAt=#{booking_date}"
        browser.goto link
        sleep 10
        puts "Clicked on the link"

        # Set window size for consistent behavior
        browser.driver.manage.window.resize_to(1920, 1080)
        sleep 5

        # Wait for page to load and find elements
        browser.wait_until(timeout: 30) { browser.divs(class: "MuiGrid-root").any? }

        grid_divs = browser.divs(class: "MuiGrid-root")

        aquagym_tonic_card =
          grid_divs.find do |card|
            card.text.gsub(/\s+/, " ").match?(/#{booking_hour}.*#{course}.*BOOK/i) &&
              card.text.size < 200
          end
        raise "No available slots found!" unless aquagym_tonic_card

        # Scroll to the element to ensure it's visible
        browser.execute_script(
          "arguments[0].scrollIntoView({behavior: 'smooth', block: 'center'});",
          aquagym_tonic_card,
        )
        sleep 2

        button = aquagym_tonic_card.buttons.find { |btn| btn.text.match?(/BOOK/i) }

        if button
          # Ensure button is visible and clickable
          browser.execute_script(
            "arguments[0].scrollIntoView({behavior: 'smooth', block: 'center'});",
            button,
          )
          sleep 2

          # Try clicking with JavaScript if regular click fails
          begin
            button.click
          rescue => e
            puts "Regular click failed, trying JavaScript click: #{e.message}"
            browser.execute_script("arguments[0].click();", button)
          end
        else
          raise "BOOK button not found in the card"
        end
        sleep 10
      rescue StandardError => e
        puts "Error during booking process: #{e.message}"
        puts "Error class: #{e.class}"
        puts "Backtrace: #{e.backtrace.first(5).join("\n")}" if e.backtrace
        raise e
      ensure
        browser.close if browser
      end
    end

    begin
      puts "Environment: #{on_heroku? ? "Heroku" : "Local"}"
      puts "Headless mode: #{headless_mode}"
      puts "Booking for #{course} for #{booking_date} at #{booking_hour}..."

      book_for_user(ENV["LA_VAGUE_USERNAME_ANNAMARIA"], ENV["LA_VAGUE_PASSWORD_ANNAMARIA"])
      puts "Successfully booked for #{course}."

      puts "#{course} session successfully booked for both users on #{booking_date} at #{booking_hour}."
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      puts "Error class: #{e.class}"
      puts "Running on Heroku - this might be due to headless browser limitations" if on_heroku?
    end
  end
end
