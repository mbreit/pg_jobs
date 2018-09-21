[![Gem](https://img.shields.io/gem/v/pg_jobs.svg)](https://rubygems.org/gems/pg_jobs)
[![license MIT](https://img.shields.io/github/license/mbreit/pg_jobs.svg)](https://github.com/mbreit/pg_jobs/blob/codeclimate/MIT-LICENSE)
[![build](https://img.shields.io/travis/com/mbreit/pg_jobs/master.svg)](https://travis-ci.com/mbreit/pg_jobs)
[![maintainability](https://img.shields.io/codeclimate/maintainability/mbreit/pg_jobs.svg)](https://codeclimate.com/github/mbreit/pg_jobs)
[![coverage](https://img.shields.io/codeclimate/coverage/mbreit/pg_jobs.svg)](https://codeclimate.com/github/mbreit/pg_jobs)
[![docs](https://inch-ci.org/github/mbreit/pg_jobs.svg?branch=master)](https://inch-ci.org/github/mbreit/pg_jobs)

# PgJobs

Simple Active Job worker for PostgreSQL using LISTEN/NOTIFY and
SKIP LOCKED.

Supports most Active Job features like multiple queues, priorities
and wait times.

## Dependencies

* PostgreSQL >= 9.5 to use SKIP LOCKED
* Ruby >= 2.3
* Rails >= 5.1

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
bin/rails pg_jobs_engine:install:migrations
bin/rails db:migrate
```

To configure the Active Job adapter add this to your environment
configuration (config/environments/production.rb):

```ruby
config.active_job.queue_adapter = :pg_jobs
```

If you want to run all your jobs in one queue, we recommend to configure
ActionMailer to use the `default` queue:

```ruby
config.action_mailer.deliver_later_queue_name = 'default'
```

## Usage

Just schedule your work with Active Job, then run one or multiple
workers for the default queue with

```bash
bin/rails runner PgJobs.work
```

or for other queues with

```bash
bin/rails runner "PgJobs.work(:my_queue)"
```

For more documentation about Active Job and how to use different queues,
scheduled jobs, priorities and error handling, see the
[Active Job Rails Guide](https://guides.rubyonrails.org/active_job_basics.html).

## Contributing

Use Github issues and pull requests.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
