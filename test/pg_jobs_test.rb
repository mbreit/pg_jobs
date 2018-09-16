require 'test_helper'

class PgJobsTest < ActiveSupport::TestCase
  include NotifyJobHelper

  self.use_transactional_tests = false

  test 'perform_later create a due job' do
    assert_difference -> { PgJob.due.count }, 1 do
      TestJob.perform_later
    end
  end

  test 'perform_later with wait does not create a due job' do
    assert_difference -> { PgJob.due.count }, 0 do
      TestJob.set(wait: 1.hour).perform_later
    end
  end

  test 'options are saved with the job' do
    TestJob.perform_later(42, foo: 'bar')
    job = ActiveJob::Base.deserialize(PgJob.last.job_data)
    job.send(:deserialize_arguments_if_needed)
    assert_equal job.arguments, [42, { foo: 'bar' }]
  end

  test 'jobs with same priority are executed in order' do
    perform_notify_job('1')
    perform_notify_job('2')

    assert_job_execution('1')
    assert_job_execution('2')
  end

  test 'jobs with lower priority are executed first' do
    PgJob.transaction do
      perform_notify_job('1', priority: '10')
      perform_notify_job('2', priority: '5')
    end

    assert_job_execution('2')
    assert_job_execution('1')
  end

  test 'jobs with other queue name are not executed' do
    perform_notify_job('1', queue: 'foobar')
    perform_notify_job('2')

    assert_job_execution('2')
  end

  test 'jobs with wait time are not executed now' do
    perform_notify_job('1', wait: 1.hour)
    perform_notify_job('2')

    assert_job_execution('2')
  end
end
