begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'PgJobs'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'bundler/gem_tasks'

namespace :db do
  task :init do
    require 'zlib'
    require 'active_record'

    ActiveRecord::Base.configurations = YAML.load_file('test/database.yml')
    ActiveRecord::Tasks::DatabaseTasks.migrations_paths = [File.expand_path('db/migrate', __dir__)]
  end

  desc 'Create test database'
  task create: :init do
    ActiveRecord::Tasks::DatabaseTasks.create_current('test')
  end

  desc 'Migrate test database'
  task migrate: :init do
    ActiveRecord::Tasks::DatabaseTasks.migrate
  end
end

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'app/models'
  t.test_files = FileList['test/**/*_test.rb']
end

task default: ['db:create', 'db:migrate', :test]
