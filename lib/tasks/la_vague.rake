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

    def courses
      course_string = ENV["COURSE"] || "Aquagym tonic mardi matin"
      course_string.split(";").map(&:strip)
    end

    def booking_hours
      hour_string = ENV["BOOKING_HOUR"] || "12:15"
      hour_string.split(";").map(&:strip)
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

    def login_user(browser, username, password)
      puts "Starting browser session for user: #{username}"
      browser.goto "https://member.resamania.com/equalia-lavagueCPS/"

      # Wait for login button and click
      browser.wait_until(timeout: 30) { browser.button(value: "Log in").present? }
      browser.button(value: "Log in").click
      sleep 5

      # Fill username
      browser.wait_until(timeout: 30) do
        browser.text_field(id: "login_step_login_username").present?
      end
      login_field = browser.text_field(id: "login_step_login_username")
      login_field.set username

      browser.button(value: "Fill in my password").click
      sleep 5

      # Fill password
      browser.wait_until(timeout: 30) { browser.text_field(id: "_password").present? }
      password_field = browser.text_field(id: "_password")
      password_field.set password

      browser.button(value: "Log into my club").click
      sleep 5
      puts "Logged in successfully"
    end

    def book_course(browser, course, hour)
      puts "Booking #{course} at #{hour}..."

      link =
        "https://member.resamania.com/equalia-lavagueCPS/planning?club=%2Fequalia%2Fclubs%2F1238&startedAt=#{booking_date}"
      browser.goto link
      sleep 5

      # Set window size for consistent behavior
      browser.driver.manage.window.resize_to(1920, 1080)
      sleep 3

      # Wait for page to load and find elements
      browser.wait_until(timeout: 30) { browser.divs(class: "MuiGrid-root").any? }

      grid_divs = browser.divs(class: "MuiGrid-root")

      course_card =
        grid_divs.find do |card|
          card_text = card.text.gsub(/\s+/, " ")

          # Use partial matching for course name to handle truncation
          course_words = course.split(" ")
          first_few_words = course_words.take(3).join(".*")
          card_text.match?(/#{hour}.*#{first_few_words}.*BOOK/i) && card_text.size < 200
        end

      raise "No available slots found for #{course} at #{hour}!" unless course_card

      # Scroll to the element to ensure it's visible
      browser.execute_script(
        "arguments[0].scrollIntoView({behavior: 'smooth', block: 'center'});",
        course_card,
      )
      sleep 1

      button = course_card.buttons.find { |btn| btn.text.match?(/BOOK/i) }

      if button
        # Ensure button is visible and clickable
        browser.execute_script(
          "arguments[0].scrollIntoView({behavior: 'smooth', block: 'center'});",
          button,
        )
        sleep 1

        # Try clicking with JavaScript if regular click fails
        begin
          button.click
        rescue => e
          browser.execute_script("arguments[0].click();", button)
        end
        puts "✓ Successfully booked #{course} at #{hour}"
      else
        raise "BOOK button not found for #{course} at #{hour}"
      end
      sleep 3
    end

    def book_for_user(username, password)
      browser = create_browser

      begin
        login_user(browser, username, password)

        course_list = courses
        hour_list = booking_hours

        if course_list.length != hour_list.length
          raise "Number of courses (#{course_list.length}) must match number of booking hours (#{hour_list.length})"
        end

        booking_results = []
        course_list.each_with_index do |course, index|
          hour = hour_list[index]
          begin
            book_course(browser, course, hour)
            booking_results << { course: course, hour: hour, status: :success }
          rescue StandardError => e
            error_msg = "#{e.message}"

            # If it's an unexpected error (not our custom messages), show more details
            unless e.message.include?("No available slots") ||
                     e.message.include?("BOOK button not found")
              error_msg += "\nError type: #{e.class}"
              error_msg += "\nBacktrace:\n  #{e.backtrace.first(3).join("\n  ")}" if e.backtrace
            end
            puts "Failed to book #{course} at #{hour}: #{error_msg}"
            booking_results << { course: course, hour: hour, status: :failed, error: e.message }
          end
        end

        # Report results
        puts "\n--- Booking Summary ---"
        booking_results.each do |result|
          if result[:status] == :success
            puts "✓ Successfully booked: #{result[:course]} at #{result[:hour]}"
          else
            puts "✗ Failed to book: #{result[:course]} at #{result[:hour]} - #{result[:error]}"
          end
        end
      rescue StandardError => e
        puts "\n❌ Critical error during booking process:"
        puts "Message: #{e.message}"
        puts "Type: #{e.class}"
        puts "Backtrace:\n  #{e.backtrace.first(5).join("\n  ")}" if e.backtrace
        raise e
      ensure
        browser.close if browser
      end
    end

    begin
      puts "=" * 60
      puts "LA VAGUE BOOKING AUTOMATION"
      puts "=" * 60
      puts "Environment: #{on_heroku? ? "Heroku" : "Local"}"
      puts "Booking date: #{booking_date}"
      puts "Courses to book: #{courses.length}"
      courses.each_with_index do |course, index|
        puts "  #{index + 1}. #{course} at #{booking_hours[index]}"
      end
      puts "=" * 60
      puts ""

      book_for_user(ENV["LA_VAGUE_USERNAME_ANNAMARIA"], ENV["LA_VAGUE_PASSWORD_ANNAMARIA"])
    rescue StandardError => e
      puts "\n❌ Fatal error occurred:"
      puts "Message: #{e.message}"
      puts "Type: #{e.class}"
      if e.backtrace
        puts "Backtrace:"
        e.backtrace.first(10).each { |line| puts "  #{line}" }
      end
      if on_heroku?
        puts "\nNote: Running on Heroku - this might be due to headless browser limitations"
      end
    end
  end
end
