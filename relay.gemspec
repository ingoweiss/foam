Gem::Specification.new do |gem|
  gem.name    = 'relay'
  gem.version = '0.0.3'
  gem.summary = ''
  gem.authors = ['Ingo Weiss']
  gem.summary = 'A scaffold meta-generator'
  gem.description = 'Relay is a meta generator for generating scaffold for a Rails application from a description of the application\'s resource layout'
  gem.email = 'ingo@ingoweiss.com'
  gem.homepage = 'http://www.github.com/ingoweiss'
  
  gem.files = Dir['lib/**/*']
  gem.add_dependency 'rails', '~> 3.0'
end