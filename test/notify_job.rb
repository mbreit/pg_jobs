class NotifyJob < ActiveJob::Base
  def perform(name, id)
    ActiveRecord::Base.connection.execute("NOTIFY #{name}, '#{id}'")
  end
end
