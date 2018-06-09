require 'test_helper'
require 'test_job'

class PgJobsTest < ActiveSupport::TestCase
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
end
