module NotifyJobHelper
  def setup
    PgJob.connection.execute "LISTEN #{worker_queue_job_name}"
    while ActiveRecord::Base.connection.raw_connection.notifies; end
  end

  def teardown
    PgJob.connection.execute "UNLISTEN #{worker_queue_job_name}"
  end

  def assert_job_execution(id = name)
    notify_name = PgJob.connection.raw_connection.wait_for_notify(1) do |_event, _pid, payload|
      assert_equal id, payload
    end

    assert_equal worker_queue_job_name, notify_name
  end

  def perform_notify_job(id = name, **opts)
    NotifyJob.set(opts.reverse_merge(queue: worker_queue_name))
             .perform_later(worker_queue_job_name, id)
  end

  def worker_queue_name
    "worker_#{Process.pid}"
  end

  def worker_queue_job_name
    "#{worker_queue_name}_#{name}"
  end
end
