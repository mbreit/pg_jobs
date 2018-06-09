class TestJob < ActiveJob::Base
  def perform(*options)
    puts "Perform #{options.inspect}"
  end
end
