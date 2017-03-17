class PgJob < ApplicationRecord
  scope :due, -> { where('scheduled_for IS NULL OR scheduled_for <= ?', Time.current) }
  scope :unprocessed, -> { where(performed_at: nil) }
  scope :queue, ->(name) { where(queue_name: name).unprocessed.order(:priority, :created_at) }

  validates :queue_name, format: {with: /\A[a-zA-Z1-9_]+\z/}

  after_create :notify_workers

  # Yields a single job from the given queue that is scheduled for
  # execution now. Does not block.
  #
  # Uses row locking with `SELECT ... FOR UPDATE SKIP LOCKED`
  # to prevent race conditions.
  #
  # Returns false if no job has been found.
  #
  # @param queue_name [String] Name of the queue to look for a due job
  def self.yield_job(queue_name)
    transaction do
      job = queue(queue_name).due.lock('FOR UPDATE SKIP LOCKED').first
      return false unless job
      yield job
      job.performed_at = Time.current
      job.save(validate: false)
    end
  end

  # Yields jobs when they are schedules to be executed.
  # If the job queue is empty, it uses PostgreSQL LISTEN/NOTIFY support
  # to block and wait for new jobs.
  #
  # @param queue_name [String] The name of the queue to work on
  # @param timeout [integer] Interval to check for due jobs
  def self.yield_jobs(queue_name, timeout, &block)
    connection.execute "LISTEN pg_jobs_#{queue_name}"
    loop do
      # Consume all pending NOTIFY events
      while connection.raw_connection.notifies; end
      # Work jobs as long as there are pending jobs in the queue
      while yield_job(queue_name, &block); end
      # Wait for next NOTIFY event
      connection.raw_connection.wait_for_notify(timeout)
    end
  ensure
    connection.execute "UNLISTEN pg_jobs_#{queue_name}"
  end

  # Notifies job workers that a new job is present using
  # PostgreSQL NOTIFIY.
  def notify_workers
    PgJob.connection.execute "NOTIFY pg_jobs_#{queue_name}"
  end
end
