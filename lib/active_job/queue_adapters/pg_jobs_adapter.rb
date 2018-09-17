module ActiveJob
  module QueueAdapters
    # Adapter for ActiveJob to run jobs with pg_jobs
    #
    # This lives in ActiveJob::QueueAdapters module so it can be used with
    # config.active_job.queue_adapter = :pg_jobs
    class PgJobsAdapter
      def enqueue(job)
        PgJobs.enqueue(job)
      end

      def enqueue_at(job, timestamp)
        PgJobs.enqueue(job, timestamp)
      end
    end
  end
end
