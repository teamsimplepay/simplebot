require "videographer/version"
require "capybara"

module Videographer
  class Error < StandardError; end
  # Your code goes here...
end

# TODO: better place for this:
Capybara.default_driver = :selenium_chrome_headless
