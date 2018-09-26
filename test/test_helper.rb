# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Setup simplecov
require 'simplecov'
SimpleCov.start

# Load Rails with ActiveJob and ActiveRecord
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'

# Load Rails test helpers
require 'rails/test_unit/railtie'
require 'rails/test_help'
require 'rails/test_unit/reporter'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Configure ActiveRecord from test/database.yml
ActiveRecord::Base.configurations = YAML.load_file('test/database.yml')

# Set up logging
Rails.logger ||= Logger.new(STDOUT)
ActiveJob::Base.logger = Rails.logger
ActiveRecord::Base.logger = Rails.logger
Rails.logger.level = ENV['DEBUG'].present? ? :debug : :warn

# Require PgJobs classes and configure ActiveJob adapter
require 'pg_job'
require 'pg_jobs'
require 'active_job/queue_adapters/pg_jobs_adapter'
ActiveJob::Base.queue_adapter = :pg_jobs

# Require the test job and spawn a child process with the worker
require 'test_job'
require 'notify_job'
require 'notify_job_helper'

parent_pid = Process.pid

worker_pid = fork do
  SimpleCov.start
  SimpleCov.command_name 'worker'
  ActiveRecord::Base.establish_connection
  PgJobs.work("worker_#{parent_pid}", timeout: 1)
end

# Stop worker process after test run
Minitest.after_run do
  Process.kill('INT', worker_pid)
  Process.wait(worker_pid)
end

ActiveRecord::Base.establish_connection

# Delete left over jobs from previous test runs
PgJob.delete_all
