module ActiveJob
  module QueueAdapters
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
