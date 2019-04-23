require 'capybara/dsl'
require 'headless'
require 'selenium/webdriver'

module Videographer
  class Video
    include Capybara::DSL

    def initialize
      @speech_provider = SpeechProvider::AwsPolly.new
    end

    def record(filename)
      Capybara.register_driver :chrome_full_screen do |app|
        port = 9515 # Selenium::WebDriver::Chrome::Service::DEFAULT_PORT + port_offset
        # The --app part is what actually seems to put in in proper full screen:
        options = Selenium::WebDriver::Chrome::Options.new(args: %w(--start-fullscreen disable-infobars) + ["--app=http://127.0.0.1:#{port}/"])
        Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, port: port)
      end
      Capybara.default_driver = :chrome_full_screen
      @session = Capybara::Session.new(:chrome_full_screen)
      @headless = Headless.new(dimensions: "1280x720x24", video: { provider: :ffmpeg, log_file_path: STDERR, devices: ["-draw_mouse 0"], extra: ["-draw_mouse 0 -hide_banner"] } ) # Can't seem to install avconv (the default) on Ubuntu
      @headless.start
      @headless.video.start_capture
      script
      # puts "About to save:"
      @headless.video.stop_and_save(filename)
    end

    def preview
      @session = Capybara::Session.new(:selenium_chrome)
      script
    end

    def saying(text)
      wav = @speech_provider.wav(text)
    end
  end
end
