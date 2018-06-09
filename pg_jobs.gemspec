$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'pg_jobs/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'pg_jobs'
  s.version     = PgJobs::VERSION
  s.authors     = ['Moritz Breit']
  s.email       = ['mail@moritz-breit.de']
  s.homepage    = 'https://github.com/mbreit/pg_jobs/'
  s.summary     = 'Simple ActiveJob queue for PostgreSQL using LISTEN/NOTIFY'
  s.description = 'Simple ActiveJob queue for PostgreSQL using LISTEN/NOTIFY'
  s.license     = 'MIT'

  s.files = Dir['{app,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 5.0'

  s.add_dependency 'pg'

  s.add_development_dependency 'minitest', '~> 5.9.0'
end
