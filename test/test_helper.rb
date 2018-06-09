# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

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
ActiveRecord::Base.establish_connection

# Require PgJobs classes and configure ActiveJob adapter
require 'pg_job'
require 'pg_jobs'
require 'active_job/queue_adapters/pg_jobs_adapter'
ActiveJob::Base.queue_adapter = :pg_jobs
