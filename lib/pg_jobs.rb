require 'pg_jobs/engine'
require 'active_job/queue_adapters/pg_jobs_adapter'

# Simple ActiveJob worker for PostgreSQL using LISTEN/NOTIFY and
# SKIP LOCKED.
#
# Supports most ActiveJob features like multiple queues, priorities
# and wait times.
#
# To use this as your Rails job queue, add this to your environment
# configuration (config/environments/production.rb):
#
#   config.active_job.queue_adapter = :pg_jobs
#
# Then run one or multiple workers for the default queue with
#
#   bin/rails runner PgJobs.work
#
# or for other queues with
#
#   bin/rails runner "PgJobs.work(:my_queue)"
#
# Needs PostgreSQL 9.5 to use SKIP LOCKED.
module PgJobs
  # Run a worker process for a given queue name.
  # Will run all scheduled jobs in the queue ordered by their
  # priorities (lowest first) and then wait for PostgreSQL LISTEN
  # events to run new jobs. For jobs that are scheduled for a later
  # time, it wakes up in an interval given by the timeout parameter
  # to check for jobs that became due in the meantime.
  #
  # @param queue_name [String] The name of the queue to work on
  # @param timeout [integer] Interval to check for due jobs
  def self.work(queue_name = 'default', timeout: 10)
    PgJob.yield_jobs(queue_name, timeout) do |pg_job|
      execute_job(pg_job)
    end
  end

  # Enqueue a new job to run at a given time or immediately
  #
  # @param job [ActiveJob::Base] The ActiveJob job object to schedule
  # @param scheduled_for [Integer,Time] Timestamp when the job should be
  #   executed. Use nil if the job should be run immediately.
  def self.enqueue(job, scheduled_for = nil)
    PgJob.create!(job_data: job.serialize,
                  scheduled_for: scheduled_for && Time.zone.at(scheduled_for),
                  priority: job.priority || 100,
                  queue_name: job.queue_name || 'default')
  end

  # Execute a PgJob instance. Calls `ActiveJob::Base.execute`.
  def self.execute_job(pg_job)
    ActiveJob::Base.execute(pg_job.job_data)
  rescue => e
    Rails.logger.error("Error while executing job: #{e}\n" + e.backtrace.join('\n'))
  end
end
