class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :pg_jobs, id: :uuid do |t|
      t.jsonb :job_data, null: false
      t.integer :priority, default: 100, null: false
      t.string :queue_name, null: false, default: 'default'

      t.timestamp :created_at, null: false
      t.timestamp :scheduled_for
      t.timestamp :performed_at
    end
    add_index :pg_jobs, %i(queue_name scheduled_for priority created_at),
              where: 'performed_at IS NULL',
              name: 'index_pg_jobs_worker'
  end
end
