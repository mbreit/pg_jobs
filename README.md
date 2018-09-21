[![Gem](https://img.shields.io/gem/v/pg_jobs.svg)](https://rubygems.org/gems/pg_jobs)
[![license MIT](https://img.shields.io/github/license/mbreit/pg_jobs.svg)](https://github.com/mbreit/pg_jobs/blob/codeclimate/MIT-LICENSE)
[![build](https://img.shields.io/travis/com/mbreit/pg_jobs.svg)](https://travis-ci.com/mbreit/pg_jobs)
[![maintainability](https://img.shields.io/codeclimate/maintainability/mbreit/pg_jobs.svg)](https://codeclimate.com/github/mbreit/pg_jobs)
[![coverage](https://img.shields.io/codeclimate/coverage/mbreit/pg_jobs.svg)](https://codeclimate.com/github/mbreit/pg_jobs)

# PgJobs

Simple ActiveJob worker for PostgreSQL using LISTEN/NOTIFY and
SKIP LOCKED.

Supports most ActiveJob features like multiple queues, priorities
and wait times.

## Dependencies

* PostgreSQL >= 9.5 to use SKIP LOCKED
* Ruby >= 2.3
* Rails >= 5.1

## Usage

Just schedule your work with ActiveJob, then run one or multiple
workers for the default queue with

```bash
bin/rails runner PgJobs.work
```

or for other queues with

```bash
bin/rails runner "PgJobs.work(:my_queue)"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pg_jobs'
```

And then execute:

```bash
bundle
```

Then copy the migrations and migrate your database:

```bash
bin/rails railties:install:migrations
bin/rails db:migrate
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
