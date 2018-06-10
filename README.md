# PgJobs
Simple ActiveJob worker for PostgreSQL using LISTEN/NOTIFY and
SKIP LOCKED.

Supports most ActiveJob features like multiple queues, priorities
and wait times.

Needs PostgreSQL 9.5 to use SKIP LOCKED.

## Usage
Just schedule your work with ActiveJob, then run one or multiple
workers for the default queue with
```bash
$ bin/rails runner PgJobs.work
```
or for other queues with
```bash
$ bin/rails runner "PgJobs.work(:my_queue)"
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pg_jobs'
```

And then execute:
```bash
$ bundle
```

Then copy the migrations and migrate your database:
```bash
$ bin/rails railties:install:migrations
$ bin/rails db:migrate
```

To configure the ActiveJob adapter add this to your environment
configuration (config/environments/production.rb):
```ruby
config.active_job.queue_adapter = :pg_jobs
```

## Contributing
Use Github issues and pull requests.

## License
The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
