require "test_helper"
require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [ 1440, 900 ], browser_options: { 'no-sandbox': nil })
end

Capybara.default_max_wait_time = 4 # seconds
Capybara.disable_animation = true

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite
end
